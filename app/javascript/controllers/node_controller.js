import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="node"
export default class extends Controller {
  connect() {
    // createConsumer().subscriptions.create({ channel: "NodeChannel", room: this.element.dataset.nodeid }, {
    //   received(data) {
    //     if (data.action == "updated") {
    //       alert("refresh")
    //     }
    //   }
    // })
  }
}
