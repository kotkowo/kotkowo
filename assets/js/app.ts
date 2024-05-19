import 'phoenix_html'
import { Socket } from 'phoenix'
import { LiveSocket } from 'phoenix_live_view'
import topbar from '../vendor/topbar'
import Alpine from 'alpinejs'
import type { AlpineComponent } from 'alpinejs'
import breakpoint from 'alpinejs-breakpoints'

function open_share_modal(href: string, quote: string) : void {
    console.warn('Web Share Api is not supported by the current browser.');
    const share_dialog = document.getElementById("share-dialog")
    share_dialog.showModal()
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
    show() {
      this.percentage = 100
      if (this.interval !== undefined) clearInterval(this.interval)

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
    var showdown = require('showdown');
    const converter = new showdown.Converter({"simpleLineBreaks": true})
   showdown.extension('tailwind-ol', function() {
    return [{
      type: 'output',
      filter: function(text) {
        return text.replace(/<ol>/g, '<ol class="list-decimal list-inside">');
      }
    }];
  });

  // Add the extension to the converter
  converter.addExtension('tailwind-ol');
    let content = this.el.getAttribute("article-content")
    content = converter.makeHtml(content);
    this.pushEvent("set_content", {content: content})
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
