#if !defined(TARGET_RASPBERRY_PI)

#include "ofxAvFoundationHLSPlayer.h"


ofxAvFoundationHLSPlayer::ofxAvFoundationHLSPlayer()
{
    videoPlayer = NULL;
    pixels = NULL;
    duration = 0;
    pixelSize = 0;
}

ofxAvFoundationHLSPlayer::~ofxAvFoundationHLSPlayer()
{
    if (videoPlayer) {
        
        if(pixels)
        {
            pixels = NULL;
        }
        
        [videoPlayer release];
        videoPlayer = NULL;
    }
}



bool ofxAvFoundationHLSPlayer::load(string name)
{
    
    videoPlayer = [[AVFPlayer alloc] init];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithUTF8String:name.c_str()]];
    
    [videoPlayer loadFromURL:url];
    
    cout << videoPlayer <<endl;

}

float ofxAvFoundationHLSPlayer::getDuration()
{
    return [videoPlayer duration];
}

void ofxAvFoundationHLSPlayer::update()
{

    
    if([videoPlayer isPlaying])
    {
        if([videoPlayer isReady])
        {
            [videoPlayer update];
    
            
            if([videoPlayer hasErrors])
            {
                for (NSString* errorString in videoPlayer.errorStrings)
                {
                    const char *cString = [errorString UTF8String];
                    errors.push_back(cString);
                }
                [videoPlayer clearErrors];
            }
        }
    }
}

float ofxAvFoundationHLSPlayer::getWidth() {
    return [videoPlayer getWidth];
}

float ofxAvFoundationHLSPlayer::getHeight() {
    return [videoPlayer getHeight];
}

ofTexture&  ofxAvFoundationHLSPlayer::getTexture() {
    return videoPlayer->outputTexture;
}


void ofxAvFoundationHLSPlayer::drawDebug()
{
    
    if(videoPlayer->outputTexture.isAllocated())
    {
        videoPlayer->outputTexture.draw(0, 0);
    }
    if(videoPlayer->outputTexture.isAllocated())
    {
        int scaledWidth = videoPlayer->width*.25;
        int scaledHeight = videoPlayer->height*.25;
        videoPlayer->outputTexture.draw(ofGetWidth()-scaledWidth,
                                        ofGetHeight()-scaledHeight,
                                        scaledWidth,
                                        scaledHeight);
    }
}

void ofxAvFoundationHLSPlayer::draw(float x, float y, float width, float height)
{
    if(videoPlayer->outputTexture.isAllocated())
    {
        videoPlayer->outputTexture.draw(x,
                                        y,
                                        width,
                                        height);
    }
}

void ofxAvFoundationHLSPlayer::draw(float x, float y)
{
    /*
    if(outputTexture.isAllocated())
    {
        outputTexture.draw(x, y);
    }
     */
    [videoPlayer draw];
}

float ofxAvFoundationHLSPlayer::getCurrentTime()
{
    if(![videoPlayer isPlaying])
    {
        return 0;
    }
    return [videoPlayer getCurrentTime];
}

void ofxAvFoundationHLSPlayer::seekToTimeInSeconds(int seconds)
{
    [videoPlayer seekToTimeInSeconds:seconds];
}


void ofxAvFoundationHLSPlayer::togglePause()
{
    [videoPlayer togglePause];

}
#endif
void ofxAvFoundationHLSPlayer::mute()
{
    [videoPlayer mute];
    
}

void ofxAvFoundationHLSPlayer::stop()
{
    [videoPlayer dealloc];
    videoPlayer = NULL;
    pixels = NULL;
    duration = 0;
    pixelSize = 0;
    //[AVFPlayer dealloc]
    
}


string ofxAvFoundationHLSPlayer::getInfo()
{
    
    if(![videoPlayer isPlaying])
    {
        return "NOT PLAYING";
    }
    
    if(![videoPlayer isReady])
    {
        return "NOT READY";
    }
    stringstream info;
    //info << "width: " << width << endl;
    //info << "height: " << height << endl;
    info << "currentTime: " << getCurrentTime() << endl;
    info << "duration: " << duration << endl;
    info << "isFrameNew: " << [videoPlayer isFrameNew] << endl;

    
    
    return info.str();
}
