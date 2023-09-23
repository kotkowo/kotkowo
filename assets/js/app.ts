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

liveSocket.connect()

window.liveSocket = liveSocket

Alpine.plugin(breakpoint)
Alpine.start()
