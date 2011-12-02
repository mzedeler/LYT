# This module handles playback of current media and timing of transcript updates

# todo: provide a visual cue on the next and previous section buttons if there are no next or previous section.

LYT.player = 
  ready: false 
  el: null
  media: null #id, start, end, html
  section: null
  time: ""
  book: null #reference to an instance of book class
  togglePlayButton: null
  nextButton: null
  previousButton: null
  playing: false
  
  playIntentOffset: null
  playIntentFlag: false
  # todo: consider array of all played sections and a few following
  
  SILENTMEDIA: "http://m.nota.nu/sound/dixie.mp3" #dixie chicks as we test, replace with silent mp3 when moving to production
  
  setup: ->
    log.message 'Player: starting setup'
    # Initialize jplayer and set ready True when ready
    @el = jQuery("#jplayer")
    
    @togglePlayButton = jQuery("a.toggle-play")
    @nextButton = jQuery("a.next-section")
    @previousButton = jQuery("a.previous-section")
    
    jplayer = @el.jPlayer
      ready: =>
        @ready = true
        log.message 'Player: setup complete'
        #@el.jPlayer('setMedia', {mp3: @SILENTMEDIA})
        #todo: add a silent state where we do not play on can play   
        
        @nextButton.click =>
          @nextSection()
        
        @previousButton.click =>
          @previousSection()
        
        @togglePlayButton.click =>
          if @playing
            @pause()
          else
            @play()
                     
      timeupdate: (event) =>
        @updateHtml(event.jPlayer.status)
      
      loadstart: (event) =>
        log.message 'load start'
        @updateHtml(event.jPlayer.status)
      
      play: (event) =>
        @setPlaying()
      
      pause: (event) =>
        @setPaused()
         
      ended: (event) =>
        @setPaused()
        @nextSection()
      
      canplay: (event) =>
        #is not called in firefox 
        log.message 'can play'
        @updateHtml(event.jPlayer.status)
        @playOnIntent()
      
      progress: (event) =>
        #is not called in chrome
        log.message 'progress'
        @updateHtml(event.jPlayer.status)
        @playOnIntent()
      
      swfPath: "./lib/jPlayer/"
      supplied: "mp3"
      solution: 'html, flash'
    
    @ready
    
  pause: ->
    # Pause current media
    @el.jPlayer('pause')
  
  silentPlay: () ->
      ###
      IOS does not allow playing audio without a direct connection to a click event
      we get around this here by starting playback of a silent audio file while 
      the book media loads.
      ###
      
      @el.jPlayer('setMedia', {mp3: @SILENTMEDIA})
      @play(0)
  
  stop: ->
    @el.jPlayer('stop')
  
  
  playOnIntent: ->
    # calls play and resets flag if the intent flag was set
    
    if @playIntentFlag
      @play(@playIntentOffset)  
      @playIntentFlag = false
      @playIntentOffset = null
              
  
  play: (time, intent = false) ->
    # Start or resume playing if media is loaded
    # Starts playing at time seconds if specified, else from 
    # when media was paused or from the beginning.
    
    if intent
      @playIntentFlag = true
      @playIntentOffset = time
      
    else
      if not time?
        @el.jPlayer('play')
      else
        @el.jPlayer('play', time)
  
  updateHtml: (status) ->
    # Continously update player rendering for current time of section
    
    return unless @book?
    return unless @media?
    
    @time = status.currentTime
    
    $("#chapter-duration").text status.duration
    $("#elapsed-time").text @time
    status.currentPercentAbsolute
    
    # render percent bar
    
    if @media.end < @time
      @book.mediaFor(@section,@time).done (media) =>
        if media?
          #log.message @media
          @media = media
          @renderTranscript()
        else
          log.message 'Player: failed to get media'
  
  renderTranscript: () ->
    #log.message("Player: render new transcript")
    jQuery("#book-text-content").html("<div id='#{@media.id}'>#{@media.html}</div>")
  
  renderTime: () ->
    null
  
  loadSection: (book, section, offset = 0, autoPlay = false) ->
    @stop()
    @book = book
    @section = section
    
    @book.mediaFor(@section, offset).done (media) =>
      #log.message media
      if media?
        @media = media
        @renderTranscript()
        @el.jPlayer('setMedia', {mp3: media.audio})
        @el.jPlayer('load')
        if autoPlay
          @play(offset, true)
      else
        log.message 'Player: failed to get media'
          
  nextSection: () ->   
    #todo: emit some event to let the app know that we should change the url to reflect the new section being played and render new section title
    return unless @media.nextSection?
    @loadSection(@book, @media.nextSection, 0, true)
    
  previousSection: () ->  
    return unless @media.previousSection?
    @loadSection(@book, @media.previousSection, 0, true)
    
  setPaused: () ->
    @togglePlayButton.find("img").attr('src', '/images/play.png')
    @playing = false
  
  setPlaying: () ->
    @togglePlayButton.find("img").attr('src', '/images/pause.png')
    @playing = true


###
  eventSystemTime: (t) ->
      total_secs = undefined
      current_percentage = undefined
      if $("#NccRootElement").attr("totaltime")?
          tt = $("#NccRootElement").attr("totaltime")
          total_secs = tt.substr(0, 2) * 3600 + (tt.substr(3, 2) * 60) + parseInt(tt.substr(6, 2))  if tt.length is 8
          total_secs = tt.substr(0, 1) * 3600 + (tt.substr(2, 2) * 60) + parseInt(tt.substr(5, 2))  if tt.length is 7
          total_secs = tt.substr(0, 2) * 3600 + (tt.substr(3, 2) * 60)  if tt.length is 5
      current_percentage = Math.round(t / total_secs * 98)
      $("#current_time").text SecToTime(t)
      $("#total_time").text $("#NccRootElement").attr("totaltime")
      $("#timeline_progress_left").css "width", current_percentage + "%"
###