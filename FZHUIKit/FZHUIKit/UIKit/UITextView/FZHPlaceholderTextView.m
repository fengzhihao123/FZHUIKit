//
//  FZHPlaceholderTextView.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/15.
//  Copyright © 2017年 冯志浩. All rights reserved.
//  Reference:https://github.com/cbowns/MPTextView

#import "FZHPlaceholderTextView.h"
// Manually-selected label offsets to align placeholder label with text entry.
static CGFloat const kLabelLeftOffset = 4.f;
static CGFloat const kLabelTopOffset = 0.f;

// When instantiated from IB, the text view has an 8 point top offset:
static CGFloat const kLabelTopOffsetFromIB = 8.f;
// On retina iPhones and iPads, the label is offset by 0.5 points:
static CGFloat const kLabelTopOffsetRetina = 0.5f;
@implementation FZHPlaceholderTextView {
    UILabel *_placeholderLabel;
    CGFloat _topLabelOffset;
}

#pragma mark - Initializers

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Account for IB offset:
        _topLabelOffset = kLabelTopOffsetFromIB;
        [self finishInitialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topLabelOffset = kLabelTopOffset;
        [self finishInitialization];
    }
    return self;
}

// Private method for finishing initialization.
// Since this class isn't documented for subclassing,
// I don't feel comfortable changing the initializer chain.
// Let's do it this way rather than overriding UIView's designated initializer.
- (void)finishInitialization {
    // Sign up for notifications for text changes:
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    CGFloat labelLeftOffset = kLabelLeftOffset;
    // Use our calculated label offset from initWith…:
    CGFloat labelTopOffset = _topLabelOffset;
    
    // On retina iPhones and iPads, the label is offset by 0.5 points.
    if ([[UIScreen mainScreen] scale] == 2.0) {
        labelTopOffset += kLabelTopOffsetRetina;
    }
    
    CGSize labelOffset = CGSizeMake(labelLeftOffset, labelTopOffset + 2);
    CGRect labelFrame = [self placeholderLabelFrameWithOffset:labelOffset];
    [self createPlaceholderLabel:labelFrame];
}

#pragma mark - Placeholder label helpers
// Create our label:
- (void)createPlaceholderLabel:(CGRect)labelFrame {
    _placeholderLabel = [[UILabel alloc] initWithFrame:labelFrame];
    _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.font = self.font;
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.text = self.placeholder;
    // Color-matched to UITextField's placeholder text color:
    _placeholderLabel.textColor = [UIColor colorWithWhite:0.71f alpha:1.0f];
    
    // UIKit effects on the UITextView, like selection ranges
    // and the cursor, are done in a view above the text view,
    // so no need to order this below anything else.
    // Add the label as a subview.
    [self addSubview:_placeholderLabel];
}

- (CGRect)placeholderLabelFrameWithOffset:(CGSize)labelOffset {
    return CGRectMake(labelOffset.width,
                      labelOffset.height,
                      self.bounds.size.width  - (2 * labelOffset.width),
                      self.bounds.size.height - (2 * labelOffset.height));
}


#pragma mark - Custom accessors
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholderLabel.text = placeholder;
    [_placeholderLabel sizeToFit];
}

#pragma mark - UITextView subclass methods
// Keep the placeholder label font in sync with the view's text font.
- (void)setFont:(UIFont *)font {
    // Call super.
    [super setFont:font];
    _placeholderLabel.font = self.font;
}

// Keep placeholder label alignment in sync with the view's text alignment.
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    // Call super.
    [super setTextAlignment:textAlignment];
    _placeholderLabel.textAlignment = textAlignment;
}

#pragma mark - UITextInput overrides
- (id)insertDictationResultPlaceholder {
    id placeholder = [super insertDictationResultPlaceholder];
    // Use -[setHidden] here instead of setAlpha:
    // these events also trigger -[textChanged],
    // which has a different criteria by which it shows the label,
    // but we undeniably know we want this placeholder hidden.
    _placeholderLabel.hidden = YES;
    return placeholder;
}

// Update visibility when dictation ends.
- (void)removeDictationResultPlaceholder:(id)placeholder willInsertResult:(BOOL)willInsertResult {
    [super removeDictationResultPlaceholder:placeholder willInsertResult:willInsertResult];
    
    // Unset the hidden flag from insertDictationResultPlaceholder.
    _placeholderLabel.hidden = NO;
    
    // Update our text label based on the entered text.
    [self updatePlaceholderLabelVisibility];
}

#pragma mark - Text change listeners
- (void)updatePlaceholderLabelVisibility {
    if ([self.text length] == 0) {
        _placeholderLabel.alpha = 1.f;
    } else {
        _placeholderLabel.alpha = 0.f;
    }
}

// When text is set or changed, update the label's visibility.
- (void)setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholderLabelVisibility];
}

- (void)textChanged:(NSNotification *)notification {
    [self updatePlaceholderLabelVisibility];
}

@end
