class Media {
    Metadata = {
        "mpris:trackid": undefined,
        "mpris:artUrl": undefined,
        "mpris:length": undefined,
        "xesam:url": location.href,
        "xesam:title": $("title").text().slice(0, -10),
    }
    PlaybackStatus = "Stopped"
    LoopStatus = undefined
    Shuffle = undefined
    Volume = undefined
    CanGoNext = undefined
    CanGoPrevious = undefined
    Rate = undefined
    Fullscreen = undefined
    Position = undefined
}

class MprisBase {
    constructor(source) {
        console.log('Mpris', 'constructor', arguments)

        this.source = source
        this.media = new Media()
        this.oldMedia = new Media()

        this.port = chrome.runtime.connect()

        this.port.onMessage.addListener(cmd => {
            var method = _.camelCase(cmd.method)

            console.log('Mpris', 'listener', method, cmd)
            
            this[method]((result) => {
                this.postMessage({
                    source: this.source, 
                    type: "return", 
                    method: cmd.method, 
                    args: result
                })
            }, ...cmd.args)
        })
    }

    get(callback, caller, key) {
        console.log('Mpris', 'get', arguments)

        this[`get${key}`](callback);
    }

    set(callback, caller, key, value) {
        console.log('Mpris', 'set', arguments)

        this[`set${key}`](callback, value);
    }

    getPosition(callback) {
        console.log('Mpris', 'getPosition', arguments)
        callback(0);
    }

    setRate(callback) {
        console.log('Mpris', 'setRate', arguments)
    }
    
    setVolume(callback) {
        console.log('Mpris', 'setVolume', arguments)
    }

    setShuffle(callback) {
        console.log('Mpris', 'setShuffle', arguments)
    }

    setLoopStatus(callback) {
        console.log('Mpris', 'setLoopStatus', arguments)
    }

    setFullscreen(callback) {
        console.log('Mpris', 'setFullscreen', arguments)
    }

    pause(callback) {
        console.log('Mpris', 'pause', arguments)
    }

    play(callback) {
        console.log('Mpris', 'play', arguments)
    }

    playPause(callback) {
        console.log('Mpris', 'playPause', arguments)
    }

    stop(callback) {
        console.log('Mpris', 'stop', arguments)
    }

    next(callback) {
        console.log('Mpris', 'next', arguments)
    }

    previous(callback) {
        console.log('Mpris', 'previous', arguments)
    }

    seek(callback, offset) {
        console.log('Mpris', 'seek', arguments)
    }

    changed(values) {
        this.postMessage({
            source: this.source, 
            type: "changed",
            args: [values]
        })
    }

    quit() {
        this.postMessage({
            source: this.source,
            type: "quit",
        });
    }
    
    postMessage(data, noLog) {
        console.log('Mpris', 'postMessage', data)
        this.port.postMessage(data)
    }
}
