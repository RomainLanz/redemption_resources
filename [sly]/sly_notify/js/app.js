$(function () {
  window.addEventListener('sly:notify', (event) => {
    if (event.data.options) {
      toastr[event.data.options.type](event.data.options.message)
    /* } else {
      var maxNotifications = event.data.maxNotifications
      Noty.setMaxVisible(maxNotifications.max, maxNotifications.queue)
    } */
  })
})
