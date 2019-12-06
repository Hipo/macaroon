#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TRYFeedbackViewController.h"
#import "TRYFeedback.h"
#import "TRYFeedbackUploadTask.h"
#import "TRYFeedbackUploadManager.h"
#import "TRYAppRelease.h"
#import "Tryouts.h"
#import "TRYMotionRecognizingWindow.h"
#import "TRYFeedbackOverlayView.h"
#import "TRYMessageView.h"

FOUNDATION_EXPORT double TryoutsVersionNumber;
FOUNDATION_EXPORT const unsigned char TryoutsVersionString[];

