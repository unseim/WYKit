//
//  UIWebView+WYJavaScript.h
//  WYKit
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <UIKit/UIKit.h>

@interface UIWebView (WYJavaScript)

#pragma mark 获取网页中的数据
/** 获取某个标签的结点个数 */
- (int)nodeCountOfTag:(NSString *)tag;

/** 获取当前页面URL */
- (NSString *)getCurrentURL;

/** 获取标题 */
- (NSString *)getTitle;

/** 获取图片 */
- (NSArray *)getImgs;

/** 获取当前页面所有链接 */
- (NSArray *)getOnURLClicks;


#pragma mark 改变网页样式和行为
/** 改变背景颜色 */
- (void)setBackgroundColor:(UIColor *)color;

/** 为所有图片添加点击事件(网页中有些图片添加无效) */
- (void)addClickEventOnImg;

/** 改变所有图像的宽度 */
- (void)setImgWidth:(int)size;

/** 改变所有图像的高度 */
- (void)setImgHeight:(int)size;

/** 改变指定标签的字体颜色 */
- (void)setFontColor:(UIColor *) color
             withTag:(NSString *)tagName;

/** 改变指定标签的字体大小 */
- (void)setFontSize:(int) size
            withTag:(NSString *)tagName;

/** 是否显示阴影 */
- (void)shadowViewHidden:(BOOL)hidden;

/** 是否显示水平滑动指示器 */
- (void)showsHorizontalScrollIndicator:(BOOL)hidden;

/** 是否显示垂直滑动指示器 */
- (void)showsVerticalScrollIndicator:(BOOL)hidden;

/** 网页透明 */
-(void)makeTransparent;

/** 网页透明移除+阴影 */
-(void)makeTransparentAndRemoveShadow;


#pragma mark 删除
/** 根据 ElementsID 删除WebView 中的节点 */
- (void)deleteNodeByElementID:(NSString *)elementID;

/** 根据 ElementsClass 删除 WebView 中的节点 */
- (void )deleteNodeByElementClass:(NSString *)elementClass;

/** 根据  TagName 删除 WebView 的节点 */
- (void)deleteNodeByTagName:(NSString *)elementTagName;


#pragma mark 读取
/** 读取一个网页地址 */
- (void)loadURL:(NSString*)URLString;

/**
 * 读取bundle中的webview
 *  @param htmlName 文件名称 xxx.html
 */
- (void)loadLocalHtml:(NSString*)htmlName;

/**
 *  读取bundle中的webview
 *  @param htmlName htmlName 文件名称 xxx.html
 *  @param inBundle bundle
 */
- (void)loadLocalHtml:(NSString*)htmlName inBundle:(NSBundle*)inBundle;

/** 清空cookie */
- (void)clearCookies;


@end
