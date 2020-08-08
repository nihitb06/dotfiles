class Spotify extends MprisBase {
    constructor() {
        console.log('Spotify', 'constructor')

        super('Spotify');
    }

    init() {
        console.log('Spotify', 'init')

        this.update()
        setInterval(() => this.update(), 2000)
    }

    getPosition(callback) {
        console.log('Spotify', 'getPosition', arguments)

        if (!$('.playback-bar__progress-time').length)
            return callback(0);

        callback(this.microSeconds($('.playback-bar__progress-time').first().text()));
    }

    setRate(callback) {
        // Not supported
    }

    setVolume(callback) {
        // Not supported
    }

    setShuffle(callback, value) {
        console.log('Spotify', 'setShuffle', value, arguments)

        if (value && $('[title="Enable shuffle"]'))
            $('[title="Enable shuffle"]').first().click();

        if (! value && $('[title="Disable shuffle"]'))
            $('[title="Disable shuffle"]').first().click();
    }

    setLoopStatus(callback, value) {
        console.log('Spotify', 'setLoop', value, arguments)   
        
        // to repeat single track, doulbe click suffle: only when suffle is disabled
        if (value === 'Playlist' && $('[title="Disable repeat"]')){
            $('[title="Disable repeat"]').click();
            setTimeout(() =>  $('[title="Enable repeat"]').click(), 750);
        }
        else if ((value === 'Playlist') && $('[title="Enable repeat"]')){
            $('[title="Enable repeat"]').click();
        }

        if ((value === 'Track') && $('[title="Enable repeat"]')){
            $('[title="Enable repeat"]').click();
            setTimeout(() =>  $('[title="Enable repeat one"]').click(), 750);
        }
        else if (value === 'Track' && $('[title="Enable repeat one"]')){
            $('[title="Enable repeat one"]').click();
        }

        if (value === 'None' && $('[title="Enable repeat one"]')){
            $('[title="Enable repeat one"]').click();
            setTimeout(() =>  $('[title="Disable repeat"]').click(), 750);
        }
        else if (value === 'None' && $('[title="Disable repeat"]')){
            $('[title="Disable repeat"]').click();
        }

    }

    setFullscreen(callback) {
        // Not supported
    }

    next(callback) {
        console.log('Spotify', 'next', arguments)

        if ($('[title="Next"]').length)
            $('[title="Next"]').first().click()

        callback()
        this.update()
    }

    previous(callback) {
        console.log('Spotify', 'previous', arguments)

        if ($('[title="Previous"]').length)
            $('[title="Previous"]').first().click()

        callback()
        this.update()
    }

    playPause(callback) {
        console.log('Spotify', 'playPause', arguments)

        if ($('[title="Pause"]').length)
            $('[title="Pause"]').first().click()

        else if ($('[title="Play"]').length)
            $('[title="Play"]').first().click()

        callback()
        this.update()
    }

    pause(callback) {
        console.log('Spotify', 'pause', arguments)

        if ($('[title="Pause"]').length)
            $('[title="Pause"]').first().click()

        callback()
        this.update()
    }

    play(callback) {
        console.log('Spotify', 'play', arguments)

        if ($('[title="Play"]').length)
            $('[title="Play"]').first().click()

        callback()
        this.update()
    }

    update = (callback) => {
        if ($('[title="Play"]').length) {
            if ($('[title="Play"]').prop('disabled'))
                this.media.PlaybackStatus = 'Stopped'
            else
                this.media.PlaybackStatus = 'Paused'
        } else if ($('[title="Pause"]').length) {
            this.media.PlaybackStatus = 'Playing'
        }
        
        if ($('[title="Next"]') && ! $('[title="Next"]').prop('disabled'))
            this.media.CanGoNext = true
        else
            this.media.CanGoNext = false

        if ($('[title="Previous"]') && ! $('[title="Previous"]').prop('disabled'))
            this.media.CanGoPrevious = true
        else
            this.media.CanGoPrevious = false
        
        if ($('.track-info__name')) {
            this.media.Metadata["mpris:trackid"] =  $('.track-info__name').first().text()
            this.media.Metadata["xesam:title"] = $('.track-info__name').first().text()
        }

        if ($('.now-playing__cover-art').length)
            this.media.Metadata["mpris:artUrl"] = this.praseUrl($('.now-playing__cover-art .cover-art-image').first().css("background-image"))


        this.media.Metadata["xesam:url"] = location.href

        if ($('.player-album').length)
            this.media.Metadata["xesam:album"] = undefined

        if ($('.track-info__artists').length) {
            this.media.Metadata["xesam:artist"] = [$('.track-info__artists').first().text()]
            this.media.Metadata["xesam:albumArtist"] = [$('.track-info__artists').first().text()]
        }
        if ($('.playback-bar__progress-time').length) {
            this.media.Metadata["mpris:length"] = this.microSeconds($('.playback-bar__progress-time:eq(1)').text())
        }

        if(! _.isEqual(this.oldMedia, this.media)){
            this.oldMedia = _.cloneDeep(this.media);
            this.changed(this.media)
        }
    }

    microSeconds(position) {
        position = position.split(':');

        if (position.length != 2)
            return 0;

        position = parseInt(position[0]) * 60 + parseInt(position[1])
        position = position * 1e6
        return position
    }

    praseUrl(url) {
        return url.replace(/.*\s?url\([\'\"]?/, '').replace(/[\'\"]?\).*/, '')
    }
}

var spotify = new Spotify()

var checkExist = setInterval(function() {
    $(window).on("load", function(){
       console.log('Spotify', 'checkExist', arguments)
       clearInterval(checkExist);
       spotify.init()
    });
 }, 100);

