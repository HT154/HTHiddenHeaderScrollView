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

#import "HTHiddenHeaderScrollView.h"
#import "HTHiddenHeaderClipView.h"

@interface HTHeaderViewTableViewRowColorView : NSView

@end

@implementation HTHeaderViewTableViewRowColorView

-(void)drawRect:(NSRect)dirtyRect{
	[super drawRect:dirtyRect];
	if(((HTHiddenHeaderScrollView *)self.superview.superview).backgroundDrawingBlock){
		((HTHiddenHeaderScrollView *)self.superview.superview).backgroundDrawingBlock((HTHiddenHeaderScrollView *)self.superview.superview, self.bounds);
	}
}

@end

@interface HTHiddenHeaderScrollView ()
- (BOOL)overRefreshView;
- (void)createHeaderView;
- (void)viewBoundsChanged:(NSNotification*)note;

- (CGFloat)minimumScroll;

@end

@implementation HTHiddenHeaderScrollView

#pragma mark - Create Header View

- (void)awakeFromNib{
	[self createHeaderView];
}

-(void)viewDidMoveToWindow{
	[self createHeaderView];
}

- (NSClipView *)contentView{
	NSClipView *superClipView = [super contentView];
	if(![superClipView isKindOfClass:[HTHiddenHeaderClipView class]]){
		NSView *documentView = superClipView.documentView;
		
		HTHiddenHeaderClipView *clipView = [[HTHiddenHeaderClipView alloc] initWithFrame:superClipView.frame];
		clipView.documentView = documentView;
		clipView.copiesOnScroll = NO;
		clipView.drawsBackground = NO;
		
		[self setContentView:clipView];
		
		superClipView = [super contentView];
		
	}
	return superClipView;
}

- (void)createHeaderView{
	[self setVerticalScrollElasticity:NSScrollElasticityAllowed];
	
	(void)self.contentView;
	
	[self.contentView setPostsFrameChangedNotifications:YES];
	[self.contentView setPostsBoundsChangedNotifications:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewBoundsChanged:) name:NSViewBoundsDidChangeNotification object:self.contentView];
	
	NSRect contentRect = [self.contentView.documentView frame];
	
	if(self.headerContentView){
		self.headerView = [[HTHeaderViewTableViewRowColorView alloc] initWithFrame:NSMakeRect(0, 0 - self.headerContentView.frame.size.height, contentRect.size.width,  self.headerContentView.frame.size.height)];
		self.headerView.autoresizingMask = NSViewWidthSizable;
		
		self.headerContentView.frame = NSMakeRect(0, 0, contentRect.size.width,  self.headerContentView.frame.size.height);
		self.headerContentView.autoresizingMask = NSViewWidthSizable;
		[self.headerView addSubview:self.headerContentView];
		
		[self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[headerContentView]-(0)-|" options:(NSLayoutFormatDirectionLeadingToTrailing | NSLayoutFormatAlignAllLeading) metrics:@{@"0": @0} views:@{@"|": self.headerView, @"headerContentView": self.headerContentView}]];
		[self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[headerContentView]-(0)-|" options:(NSLayoutFormatDirectionLeadingToTrailing | NSLayoutFormatAlignAllLeading) metrics:@{@"0": @0} views:@{@"|": self.headerView, @"headerContentView": self.headerContentView}]];
		
		[self.headerView layout];
		
		[self.contentView addSubview:self.headerView];
		
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[headerView]-(0)-|" options:(NSLayoutFormatDirectionLeadingToTrailing | NSLayoutFormatAlignAllLeading) metrics:@{@"0": @0} views:@{@"|": self.contentView, @"headerView": self.headerView}]];
	}
	
	// Scroll to top
	[self.contentView scrollToPoint:NSMakePoint(contentRect.origin.x, 0)];
	[self reflectScrolledClipView:self.contentView];
}

#pragma mark - Detecting Scroll

- (void)scrollWheel:(NSEvent *)event{
	if(event.phase == NSEventPhaseEnded){
		if([self overRefreshView] && !self.isHeld){
			[self showAndHoldView];
		}else if(![self overRefreshView] && self.isHeld){
			if (self.shouldPerformCloseOnScrollBlock) {
				if(self.shouldPerformCloseOnScrollBlock(self)){
					[self naturallyReleaseView];
				}
			}else{
				[self naturallyReleaseView];
			}
		}
	}
	
	[super scrollWheel:event];
}

- (void)viewBoundsChanged:(NSNotification *)note{
	if(self.isHeld)
		return;
	
	BOOL start = [self overRefreshView];
	if(start){
		if(self.openBlock){
			self.openBlock(self);
		}
	}else{
		if(self.closeBlock){
			self.closeBlock(self);
		}
	}
	
}

- (BOOL)overRefreshView{
	NSClipView *clipView  = self.contentView;
	NSRect bounds         = clipView.bounds;
	
	CGFloat scrollValue   = bounds.origin.y;
	CGFloat minimumScroll = self.minimumScroll;
	
	return (scrollValue <= minimumScroll);
}

- (CGFloat)minimumScroll{
	return 0 - self.headerView.frame.size.height;
}

- (void)showAndHoldView{
	[self willChangeValueForKey:@"isHeld"];
	_isHeld = YES;
	[self didChangeValueForKey:@"isHeld"];
	
	if(self.openedBlock){
		self.openedBlock(self);
	}
}

- (void)naturallyReleaseView{
	if(self.closedBlock){
		self.closedBlock(self);
	}
	
	[self willChangeValueForKey:@"isHeld"];
	_isHeld = NO;
	[self didChangeValueForKey:@"isHeld"];
}

- (void)releaseView{
	[self naturallyReleaseView];
	
	CGEventRef cgEvent = CGEventCreateScrollWheelEvent(NULL, kCGScrollEventUnitLine, 2, 1, 0);
	
	NSEvent *scrollEvent = [NSEvent eventWithCGEvent:cgEvent];
	[self scrollWheel:scrollEvent];
	CFRelease(cgEvent);
}

@end