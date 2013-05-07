$(document).ready ->

    window.imgLoadTimeout = null;
    $("#mainContent").on "scroll", ->
        clearTimeout(window.imgReloadTimeout)
        window.imgReloadTimeout = setTimeout(loadImages, 300);

    loadImages = ->
        windowTop = document.body.scrollTop - 200
        windowBottom = document.body.scrollTop + $(window).height() + 200
        $('.itemWrapper').each (index, item) ->
            $item = $(item)
            itemOffset = $item.offset().top
            hasArt = $item.find(".art").length > 0
            if itemOffset >= windowTop and itemOffset <= windowBottom and not hasArt
                img = new Image()
                img.associatedElement = item
                $img = $(img)
                $img.addClass('art')
                $img.load ->
                    fadeIn.call(img)
                img.src = item.getAttribute('data-img-url')

    fadeIn = ->
        $el = $(this.associatedElement.children[0])
        window.el = $el
        overlay = $el.children('.overlay').first()
        console.log "overlay: #{overlay}"
        $(this).insertBefore(overlay)

        # overlay.addClass "backface-visibility"
        # $el.hide().show()
        fadeOverlay = ->
            overlay.css "opacity", 0
            # setTimeout fadeDone 400
        setTimeout fadeOverlay, 50

        # fadeDone = ->
        #     overlay.removeClass "backspace-visibility"
        # setTimeout fadeDone, 400

    $ ->
        placeholder = new Image
        $(placeholder).load ->
            loadImages()
        placeholder.src = "BlankAlbum.png"

    toggledPanel = null
    $main = $("#main")
    $left = $("#left")
    $right = $("#right")
    $filter = $("#filter")
    
    focusMainPanel = (callback) ->
        $main.wbTranslate(0, 200, "ease-out", callback)
        toggledPanel = null

    switchPanels = (panel) ->
        if panel is "right"
            $right.css "display": "block"
            if isMobile then $left.css "display": "none"
            $filter.css "display": "none"
        else if panel is "left"
            $right.css "display": "none"
            if isMobile then $left.css "display": "block"
            $filter.css "display": "none"
        else if panel is "filter"
            $right.css "display": "none"
            if isMobile then $left.css "display": "none"
            $filter.css "display": "block"

    window.isMobile = if screen.width <= 768 then true else false

    if not isMobile
        rightPanelActive = true
        leftPanelActive = true
        filterPanelActive = false
        $main.addClass("transitions")
        $main.css({left: $left.width(), width: $(window).width() - $left.width() - $right.width()})

    $(window).resize ->
        leftPanelWidth = if leftPanelActive then $left.width() else 0
        rightPanelWidth = if rightPanelActive then $right.width() else if filterPanelActive then $filter.width() else 0
        $main.removeClass("transitions").css({left: leftPanelWidth, width: $(window).width() - leftPanelWidth - rightPanelWidth}).addClass("transitions")

    $(".leftPanelToggle").click ->
        if isMobile
            if toggledPanel is null
                switchPanels "left"
                $main.wbTranslate($left.width(), 200, "ease-out")
                toggledPanel = "left"
            else 
                focusMainPanel()
        else
            leftWidth = $left.width()
            if not leftPanelActive
                $main.css
                    left: leftWidth
                    width: $main.width() - leftWidth
                leftPanelActive = true
            else
                $main.css
                    left: 0
                    width: $main.width() + leftWidth
                leftPanelActive = false
    
    $(".rightPanelToggle").click ->
        if isMobile
            if toggledPanel is null or toggledPanel is "filter"
                if $main.css("left") isnt "0px" then focusMainPanel ->
                    switchPanels "right"
                    $main.wbTranslate(-$right.width(), 200, "ease-out")
                else 
                    switchPanels "right"
                    $main.wbTranslate(-$right.width(), 200, "ease-out")
                toggledPanel = "right"
            else
                focusMainPanel()
        else
            leftOffset = parseInt $main.css "left"
            rightWidth = $right.width()
            
            if not rightPanelActive
                afterFilterClose = () ->
                    switchPanels "right"
                    $main.css
                        width: $main.width() - rightWidth
                        rightPanelActive = true

                if filterPanelActive
                    $main.css
                        width: $main.width() + $filter.width()
                    setTimeout afterFilterClose, 200
                    filterPanelActive = false
                else
                    afterFilterClose()
                    
            else
                $main.css
                    width: $main.width() + rightWidth
                    rightPanelActive = false

        
    $(".filterPanelToggle").click ->
        if isMobile
            if toggledPanel is null or toggledPanel is "right"
                if $main.css("left") isnt "0px" then focusMainPanel ->
                    switchPanels "filter"
                    $main.wbTranslate(-$("#filter").width(), 200, "ease-out")
                else 
                    switchPanels "filter"
                    $main.wbTranslate(-$("#filter").width(), 200, "ease-out")
                toggledPanel = "filter"
            else
                focusMainPanel()
        else
            filterWidth = $filter.width()
            
            if not filterPanelActive
                afterRightClose = () ->
                    switchPanels "filter"
                    $main.css
                        width: $main.width() - filterWidth
                        filterPanelActive = true

                if rightPanelActive
                    $main.css
                        width: $main.width() + $right.width()
                    setTimeout afterRightClose, 200
                    rightPanelActive = false
                else
                    afterRightClose()
                    
            else
                $main.css
                    width: $main.width() + filterWidth
                    filterPanelActive = false
        
    if document.createTouch isnt undefined

        $("body").on "touchstart", (event) ->
            $top = $(event.originalEvent.srcElement).closest(".scroll")
            console.log "top: #{$top}"
            $next = $top.children().first()
            bottom = $next.height() - $top.height()
            middle = $next.height() / 2
            
            console.log "scrollTop: #{$top.scrollTop()} other: #{bottom - $top.height()}"
            if $top.scrollTop() is bottom 
                $top.scrollTop(bottom - 1) 
            else if $top.scrollTop() is 0
                $top.scrollTop(1)
    
        $("body").on "touchmove", (event) ->
            $target = $(event.target)
            $parents = $target.parents(".scroll")
            if not ($parents.length > 0 or $target.hasClass ".scroll") then e.preventDefault()
    
        $main.bind "touchstart", (event) ->
            return if event.originalEvent.touches.length isnt 1
            $this = $(this)
    
            window.touchStartX = event.originalEvent.touches[0].pageX - $this.offset().left
            window.scrollType = if touchStartX < 30 or touchStartX > $this.width() - 30 then "x" else "y"
            window.previousX = touchStartX
            window.previousTime = event.timeStamp
            window.pixelsPerSecond = 0
            
        $main.bind "touchmove", (event) ->
            return if event.originalEvent.touches.length isnt 1
            $this = $(this)

            console.log "touchmove on #{$target}"

            
            if window.scrollType is "x"
                event.preventDefault()
                x = event.originalEvent.touches[0].pageX
                window.pixelsPerSecond = (x - window.previousX) / (event.timeStamp - window.previousTime) * 1000
                
                if toggledPanel isnt "filter"
                    if $this.offset().left < 0
                        switchPanels "right"
                    else switchPanels "left"               
                $this.css left: x - window.touchStartX
            
            window.previousX = x
            window.previousTime = event.timeStamp
            
        $main.bind "touchend", (event) ->
            return if event.originalEvent.touches.length isnt 0 or window.scrollType is "y"
    
            width = $main.width()
            left = $main.offset().left
            futurePosition = left + pixelsPerSecond
            
            left = if toggledPanel is "filter"
                if futurePosition > 0
                    toggledPanel = null
                    0
                else
                    -$filter.width() 
            else 
                if futurePosition > width / 2 and left > 30
                    toggledPanel = "left"
                    console.log "left open"
                    $left.width()
                else if futurePosition < width / -2 and left < -30
                    toggledPanel = "right"
                    console.log "right open"
                    -$right.width()
                else
                    toggledPanel = null
                    console.log "center panel focus"
                    0
                
            $main.wbTranslate(left, 200, "ease-out")
            console.log "touchend"