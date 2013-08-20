//
//  HTHiddenHeaderScrollView.m
//  HTHiddenHeader
//
// Copyright (C) 2013 by HT154.

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "HTHiddenHeaderClipView.h"
#import "HTHiddenHeaderScrollView.h"

@interface HTHiddenHeaderScrollView (Private)
- (CGFloat)minimumScroll;
@end

@interface HTHiddenHeaderClipView ()
- (BOOL)isHeld;
- (NSView *)headerView;
- (CGFloat)minimumScroll;
@end

@implementation HTHiddenHeaderClipView
- (NSPoint)constrainScrollPoint:(NSPoint)proposedNewOrigin { // this method determines the "elastic" of the scroll view or how high it can scroll without resistence. 	
	NSPoint constrained = [super constrainScrollPoint:proposedNewOrigin];
	CGFloat scrollValue = proposedNewOrigin.y; // this is the y value where the top of the document view is
	BOOL over           = scrollValue <= self.minimumScroll;
	
	if (self.isHeld && scrollValue <= 0) { // if we are refreshing
		if (over) // and if we are scrolled above the refresh view
			proposedNewOrigin.y = 0 - self.headerView.frame.size.height; // constrain us to the refresh view
		
		return NSMakePoint(constrained.x, proposedNewOrigin.y);
	}
	return constrained;
}

- (BOOL)isFlipped {
	return YES; 
}

- (NSRect)documentRect { //this is to make scrolling feel more normal so that the spinner is within the scrolled area
	NSRect sup = [super documentRect];
	if (self.isHeld) {
		sup.size.height += self.headerView.frame.size.height;
		sup.origin.y    -= self.headerView.frame.size.height;
	}
	return sup;
}

- (BOOL)isHeld {
	return [(HTHiddenHeaderScrollView *)self.superview isHeld];
}

- (NSView *)headerView {
	return [(HTHiddenHeaderScrollView *)self.superview headerView];
}

- (CGFloat)minimumScroll {
	return [(HTHiddenHeaderScrollView *)self.superview minimumScroll];
}

@end
