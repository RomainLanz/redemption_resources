(function (){

	let status = []

	let renderStatus = function () {
		for (let i = 0; i < status.length; i++) {
			if (!status[i].visible) continue

			if (status[i].name == 'hunger') {
				$('#status__hunger span').html(Math.floor(status[i].val / 10000))
				continue
			}

			if (status[i].name == 'thirst') {
				$('#status__thirst span').html(Math.floor(status[i].val / 10000))
				continue
			}
		}
	}

	window.onData = function (data) {
		if (data.update) {
			
			status.length = 0

			for(let i = 0; i < data.status.length; i++)
				status.push(data.status[i])

			renderStatus()
		}
	}

	window.onload = function (e) {
		window.addEventListener('message', function (event) { onData(event.data) })
	}

})()