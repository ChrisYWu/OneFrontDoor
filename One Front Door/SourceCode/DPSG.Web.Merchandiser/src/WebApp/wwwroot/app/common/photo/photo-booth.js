"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var core_1 = require('@angular/core');
(function (State) {
    State[State["Recording"] = 0] = "Recording";
    State[State["Confirming"] = 1] = "Confirming";
})(exports.State || (exports.State = {}));
var State = exports.State;
var GotSnapshotEvent = (function () {
    function GotSnapshotEvent(blob, dataUrl) {
        this.blob = blob;
        this.dataUrl = dataUrl;
    }
    return GotSnapshotEvent;
}());
exports.GotSnapshotEvent = GotSnapshotEvent;
var PhotoBooth = (function () {
    function PhotoBooth(element, zone) {
        this.element = element;
        this.zone = zone;
        this.gotSnapshot = new core_1.EventEmitter();
        this.State = State;
        this.state = State.Recording;
    }
    PhotoBooth.prototype.ngAfterViewInit = function () {
        var _this = this;
        this.window = window;
        this.navigator = window.navigator;
        this.video = this.element.nativeElement.querySelector('#recorder').querySelector('video');
        this.navigator.getUserMedia = this.navigator.getUserMedia || this.navigator.webkitGetUserMedia || this.navigator.mozGetUserMedia || this.navigator.msGetUserMedia;
        if (this.window.stream) {
            this.releaseVideo();
            this.releaseStream();
        }
        var constraints = {
            audio: false,
            video: true
        };
        this.navigator.getUserMedia(constraints, function (stream) {
            _this.window.stream = stream; // make stream available to console
            //Success
            if (_this.navigator.mozGetUserMedia) {
                _this.video.mozSrcObject = stream;
            }
            else {
                var vendorURL = window.URL || _this.window.webkitURL;
                _this.video.src = vendorURL.createObjectURL(stream);
            }
            _this.video.play();
        }, function (error) {
            //Error
            console.log('navigator.getUserMedia error: ', error);
        });
        this.start();
    };
    PhotoBooth.prototype.start = function () {
        this.state = State.Recording;
    };
    PhotoBooth.prototype.snapshot = function () {
        var _this = this;
        if (this.window.stream) {
            this.canvas = this.element.nativeElement.querySelector('#recorder').querySelector('canvas');
            this.canvas.width = this.video.videoWidth;
            this.canvas.height = this.video.videoHeight;
            this.context = this.canvas.getContext('2d');
            this.context.drawImage(this.video, 0, 0);
            //For some reason, image/jpeg is much more efficient than png.
            //Theory 1 : It could be that toDataURL is encoding a jpeg & compressing.
            //Theory 2 : It could have been that prevously when saving as png, when we upload a jpeg it gets decompressed and saved as a png and got huge.
            this.imgSrc = this.canvas.toDataURL('image/jpeg');
            this.state = this.State.Confirming;
            this.canvas.toBlob(function (blob) {
                _this.zone.run(function () {
                    _this.gotSnapshot.emit(new GotSnapshotEvent(blob, _this.imgSrc));
                });
            });
        }
    };
    PhotoBooth.prototype.releaseStream = function () {
        if (this.window.stream) {
            //Old, deprecated way of stopping the stream using MediaStream object.
            if (this.window.stream.stop) {
                this.window.stream.stop();
            }
            else {
                this.window.stream.getAudioTracks().forEach(function (track) {
                    track.stop();
                });
                this.window.stream.getVideoTracks().forEach(function (track) {
                    track.stop();
                });
            }
            this.window.stream = null;
        }
    };
    PhotoBooth.prototype.releaseVideo = function () {
        this.video.pause();
        this.video.src = null;
        if (this.video.hasOwnProperty("mozSrcObject"))
            this.video["mozSrcObject"] = null;
    };
    PhotoBooth.prototype.ngOnDestroy = function () {
        this.releaseVideo();
        this.releaseStream();
    };
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], PhotoBooth.prototype, "gotSnapshot", void 0);
    PhotoBooth = __decorate([
        core_1.Component({
            selector: 'photo-booth',
            styles: ["\n    video {\n      width: 200px;\n      height: 200px;\n      object-fit: cover;\n    }\n    canvas {\n      display: none;\n    }\n    img {\n      width: 200px;\n      height: 200px;\n      object-fit: cover;\n    }\n"],
            template: "\n<div id=\"recorder\" [ngStyle]=\"{'display': state == State.Recording ? 'inherit' : 'none'}\">\n  <video muted autoplay (click)=\"snapshot()\"></video>\n  <canvas></canvas>\n</div>\n<div id=\"confirmer\" [ngStyle]=\"{'display': state == State.Confirming ? 'inherit' : 'none'}\">\n  <img [src]=\"imgSrc\"/>\n</div>\n"
        }), 
        __metadata('design:paramtypes', [core_1.ElementRef, core_1.NgZone])
    ], PhotoBooth);
    return PhotoBooth;
}());
exports.PhotoBooth = PhotoBooth;
//# sourceMappingURL=photo-booth.js.map