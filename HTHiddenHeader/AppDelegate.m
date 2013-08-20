//
//  AppDelegate.m
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


#import "AppDelegate.h"
#import "HTHiddenHeaderScrollView.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
	self.arrayController.content = [@[@{@"name":@"alabama"}, @{@"name": @"alaska"}, @{@"name": @"arizona"}, @{@"name": @"arkansas"}, @{@"name": @"california"}, @{@"name": @"colorado"}, @{@"name": @"connecticut"}, @{@"name": @"delaware"}, @{@"name": @"florida"}, @{@"name": @"georgia"}, @{@"name": @"hawaii"}, @{@"name": @"idaho"}, @{@"name": @"illinois"}, @{@"name": @"indiana"}, @{@"name": @"iowa"}, @{@"name": @"kansas"}, @{@"name": @"kentucky"}, @{@"name": @"louisiana"}, @{@"name": @"maine"}, @{@"name": @"maryland"}, @{@"name": @"massachusetts"}, @{@"name": @"michigan"}, @{@"name": @"minnesota"}, @{@"name": @"mississippi"}, @{@"name": @"missouri"}, @{@"name": @"montana"}, @{@"name": @"nebraska"}, @{@"name": @"nevada"}, @{@"name": @"new hampshire"}, @{@"name": @"new jersey"}, @{@"name": @"new mexico"}, @{@"name": @"new york"}, @{@"name": @"north carolina"}, @{@"name": @"north dakota"}, @{@"name": @"ohio"}, @{@"name": @"oklahoma"}, @{@"name": @"oregon"}, @{@"name": @"pennsylvania"}, @{@"name": @"rhode island"}, @{@"name": @"south carolina"}, @{@"name": @"south dakota"}, @{@"name": @"tennessee"}, @{@"name": @"texas"}, @{@"name": @"utah"}, @{@"name": @"vermont"}, @{@"name": @"virginia"}, @{@"name": @"washington"}, @{@"name": @"west virginia"}, @{@"name": @"wisconsin"}, @{@"name": @"wyoming"}] mutableCopy];
}

@end
