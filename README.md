## HEBubbleView
Easy to use iOS UI Class for providing a bubble list similar to the contact bubbles in the
iOS and OSX Mail App. Supports editing, deletion, insert, insertAtIndex, Custom UIMenuControllerItems for a given index and animation support. Working with iPad and iPhone, supports ARC. Modern Obj-C Syntax is used.


## Usage
- Refer to the **Sample Project**.
- Drag and Drop HEBubbleViewItem and HEBubbleView files to your XCode Project
- Create a UIViewController subclass and implement the HEBubbleViewDatasource and HEBubbleViewDelegate protocol
- Usage is very similar to UITableViewController/DataSource/Delegate

DataSource

```objc
-(NSInteger)numberOfItemsInBubbleView:(HEBubbleView *)bubbleView;
-(HEBubbleViewItem *)bubbleView:(HEBubbleView *)bubbleView bubbleItemForIndex:(NSInteger)index;
```

Delegate

```objc
-(void)bubbleView:(HEBubbleView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index;
-(BOOL)bubbleView:(HEBubbleView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index;
-(NSArray *)bubbleView:(HEBubbleView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index;
-(void)bubbleView:(HEBubbleView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index;
```

Create and configure the BubbleView in your ViewController

```objc
    bubbleView = [[HEBubbleView alloc] initWithFrame:self.view.frame];
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    
    // configure bubble view
    bubbleView.alwaysBounceVertical = YES;
    bubbleView.bubbleDataSource = self;
    bubbleView.bubbleDelegate = self;
    bubbleView.selectionStyle = HEBubbleViewSelectionStyleDefault
    
    [self.view addSubview:bubbleView];
    [bubbleView release];
```

- You **must override canBecomeFirstResponder** and return YES in your HEBubbleViewDelegate, otherwise MenuController callout is not shown

```objc
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
```

## License
Copyright 2012 Clemens Hammerl / Adam Eri

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
 limitations under the License. 

Attribution is appreciated.