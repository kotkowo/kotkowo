import 'phoenix_html'
import { Socket } from 'phoenix'
import { LiveSocket } from 'phoenix_live_view'
import topbar from '../vendor/topbar'
import Alpine from 'alpinejs'
import type { AlpineComponent } from 'alpinejs'
import breakpoint from 'alpinejs-breakpoints'
import DOMPurify from 'dompurify';
import {marked} from 'marked';

function open_share_modal(href: string, quote: string) : void {
    console.warn('Web Share Api is not supported by the current browser.');
    const share_dialog = document.getElementById("share-dialog")
    const share_content = document.getElementById("share-content")

    share_dialog.showModal()

    share_dialog.addEventListener('click', () => share_dialog.close());
    share_content.addEventListener('click', event => { event.stopPropagation(); });
    const facebook_share = document.getElementById("share-facebook")
    facebook_share.setAttribute("href", `https://www.facebook.com/sharer/sharer.php?u=${href}&hashtag=kotkowo`)
    const twitter_share = document.getElementById("share-twitter")
    twitter_share.setAttribute("href", `https://twitter.com/intent/tweet?url=${href}&text=${quote}`)
    const share_copy = document.getElementById("share-copy")
    share_copy.value = href
  }


function toast() : AlpineComponent<{
	percentage: number,
	show: () => void
}> {
  return {
    percentage: 0,
    show({message, icon}) {
      this.percentage = 100
      if (this.interval !== undefined) clearInterval(this.interval)
      this.$el.querySelector("#toast-message").innerHTML = message;
      this.$el.querySelector("#toast-icon").innerHTML = icon;

      this.interval = setInterval((async () => {
        await this.$nextTick()
        this.percentage -= 1
        if (this.percentage <= 0) {
          clearInterval(this.interval)
          this.percentage = 0
        }
      }) as () => void, 10)
    }
  }
}
Hooks = {}
Hooks.sanitize_article_html = {
  
  mounted(){

  const elem = this.el;
  const content = elem.getAttribute("data-article-content");
  const renderer = new marked.Renderer();
  renderer.link = function(href, title, text) {
    return `<a href="${href}" target="_blank" rel="noopener noreferrer">${text}</a>`;
  };
  elem.innerHTML = DOMPurify.sanitize(marked.parse(content, { renderer: renderer }), {ADD_ATTR: ['target']});
  }
}
Alpine.data('toast', toast)

const csrf_token = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')

window.Alpine = Alpine
const live_socket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrf_token },
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack !== undefined) {
        Alpine.clone(from, to)
      }
    }
  }
})

topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' })
window.addEventListener('phx:page-loading-start', _info =>
  topbar.delayedShow(200)
)
window.addEventListener('phx:page-loading-stop', _info => topbar.hide())
window.addEventListener('scroll_next_child', e => {
  const scrollable = e.target;
  const child_width = scrollable.children[0].offsetWidth;
  scrollable.scrollLeft = scrollable.scrollLeft + child_width

  
})
window.addEventListener('scroll_prev_child', e => {
  const scrollable = e.target;
  const child_width = scrollable.children[0].offsetWidth;
  scrollable.scrollLeft = scrollable.scrollLeft - child_width

  
})
window.addEventListener("scroll_to_top", _ => {
    window.scrollTo(0, 0);
})


window.addEventListener('share_modal', e => {
  const elem = e.target;
  const href = elem.getAttribute("share_href");
  const quote = elem.getAttribute("share_quote");
 
  if (navigator.share !== undefined) {
    navigator
    .share({
        href,
        quote
      })
    .catch(_ => {
      open_share_modal(href, quote)
    })          
  } else {
    open_share_modal(href, quote)
  }
})

window.addEventListener("hide_share", e => {
  const share_dialog = document.getElementById("share-dialog")
  share_dialog.close();
  
})

live_socket.connect()

window.live_socket = live_socket

Alpine.plugin(breakpoint)
Alpine.start()
