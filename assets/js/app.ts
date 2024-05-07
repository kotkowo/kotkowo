import 'phoenix_html'
import { Socket } from 'phoenix'
import { LiveSocket } from 'phoenix_live_view'
import topbar from '../vendor/topbar'
import Alpine from 'alpinejs'
import type { AlpineComponent } from 'alpinejs'
import breakpoint from 'alpinejs-breakpoints'

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

Alpine.data('toast', toast)

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')

window.Alpine = Alpine
const liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
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
window.addEventListener('share_modal', (e) => {
  const elem = e.target;
  const href = elem.getAttribute("share_href");
  const quote = elem.getAttribute("share_quote");

  const open_share_modal = () => {
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

  if (navigator.share) {
    navigator
    .share({
        href,
        quote
      })
    .catch((error) => {
      open_share_modal()
    })          
  } else {
    open_share_modal()
  }
})

window.addEventListener("hide_share", (e) => {
  let share_dialog = document.getElementById("share-dialog")
  share_dialog.close();
  
})

liveSocket.connect()

window.liveSocket = liveSocket

Alpine.plugin(breakpoint)
Alpine.start()
