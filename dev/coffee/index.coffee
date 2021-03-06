_gaq = _gaq || []
_gaq.push ['_setAccount', 'UA-37161265-5']
_gaq.push ['_trackPageview']

do ->
  ga = document.createElement('script')
  ga.type = 'text/javascript'
  ga.async = true
  ga.src = (if 'https:' == document.location.protocol then 'https://ssl' else 'http://www') + '.google-analytics.com/ga.js'
  s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(ga, s)

$ ->
  btnPlay = $ '#play'
  audio = new Audio()
  audio.preload = "auto";
  time =
    timeAll: null,
    timeStop: null

  play = () ->
    audio.play()

    _gaq.push(['_trackEvent', 'Shake', 'Play']);

  stop = () ->
    audio.pause()
    audio.currentTime = 0

    _gaq.push(['_trackEvent', 'Shake', 'Stop']);

  userAgent = navigator.userAgent.toLowerCase()
  type = 'ogg'
  type = 'mp3' if userAgent.indexOf("msie")>0
  type = 'm4a' if userAgent.indexOf("safari")>0

  audio.addEventListener 'loadeddata', () ->
    btnPlay.on('click', play)
    $('body').attr('class','status-ready')
    clearTimeout reload
    _gaq.push(['_trackEvent', 'Multimedia', 'Loaded'])

  audio.addEventListener 'play', () ->
    $('body').attr('class','status-start')
    $(audio).on 'timeupdate', () ->
      if audio.currentTime > 15.5
        $('body').attr('class','status-all')
        $(audio).off 'timeupdate'
    _gaq.push(['_trackEvent', 'Multimedia', 'Play'])

  audio.addEventListener 'error', (e) ->
    $('body').attr('class','status-ready')
    _gaq.push(['_trackEvent', 'Multimedia', 'Error', e])

  audio.addEventListener 'pause', () ->
    $('body').attr('class','status-ready')

    _gaq.push(['_trackEvent', 'Multimedia', 'Pause'])

  audio.addEventListener 'progress', ()->
    endVal = if this.seekable && this.seekable.length then this.seekable.end(0) else 0
    $('#load').text('LOADING... ' + (100 / (this.duration || 1) * endVal) + '%')

  audio.addEventListener 'ended', () ->
    $('body').attr('class','status-end')
    _gaq.push(['_trackEvent', 'Multimedia', 'Ended'])

  setTimeout ()->
    audio.src = 'http://sw5dev.myqnapcloud.com/wbc/harlem_shake.' + type
    audio.load()
  , 100

  reload = setTimeout () ->
    location.reload()
  , 10000