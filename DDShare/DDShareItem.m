//
//  DDShareItem.m
//  DDShareDemo
//
//  Created by Think on 2017/3/5.
//  Copyright © 2017年 Think. All rights reserved.
//

#import "DDShareItem.h"
#import "DDConst.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface DDShareItem ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation DDShareItem
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title action:(shareHandle)action
{
    NSParameterAssert(title.length || image);
    if (self = [super init]) {
        _title = title;
        _image = image;
        _action = action;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title actionName:(NSString *)actionName
{
    NSParameterAssert(title.length || image);
    if (self = [super init]) {
        _title = title;
        _image = image;
        _action = [self actionFromString:actionName];;
    }
    return self;
}

- (instancetype)initWithPlatformName:(NSString *)platformName{
    
    NSDictionary *messageDict;
    if ([platformName isEqualToString:DDPlatformNameSina]) {
        messageDict = @{@"image":@"share_sina",@"title":@"新浪微博",@"action":DDPlatformHandleSina};
    }
    if ([platformName isEqualToString:DDPlatformNameQQ]) {
        messageDict = @{@"image":@"share_qq",@"title":@"QQ",@"action":DDPlatformHandleQQ};
    }
    if ([platformName isEqualToString:DDPlatformNameEmail]) {
        messageDict = @{@"image":@"share_email",@"title":@"邮件",@"action":DDPlatformHandleEmail};
    }
    if ([platformName isEqualToString:DDPlatformNameSms]) {
        messageDict = @{@"image":@"share_sms",@"title":@"短信",@"action":DDPlatformHandleSms};
    }
    if ([platformName isEqualToString:DDPlatformNameWechat]) {
        messageDict = @{@"image":@"share_weixin",@"title":@"微信",@"action":DDPlatformHandleWechat};
    }
    if ([platformName isEqualToString:DDPlatformNameAlipay]) {
        messageDict = @{@"image":@"share_alipay",@"title":@"支付宝",@"action":DDPlatformHandleAlipay};
    }

    if (self = [super init]) {
        _title = (messageDict[@"title"] ? messageDict[@"title"] : @"");
        _image = [UIImage imageNamed:[@"DDShareImage.bundle" stringByAppendingPathComponent:messageDict[@"image"]]];
        _action = [self actionFromString:messageDict[@"action"]];
    }
    return self;
}


#pragma mark - 私有方法

//字符串转 Block
- (shareHandle)actionFromString:(NSString *)handleName{
    
    shareHandle handle = ^(DDShareItem *item){
        NSString *tipPlatform;
        if ([handleName isEqualToString:DDPlatformHandleEmail]) {
            [self sendmailTO:@""];
            return ;
        }
        if ([handleName isEqualToString:DDPlatformHandleSms]) {
            [self sendMessageTO:@""];
            return ;
        }
        /******************************各种平台***********************************************/
        NSString *platformID;
        if ([handleName isEqualToString:DDPlatformHandleSina]) {
            platformID = @"com.apple.share.SinaWeibo.post";
            tipPlatform = @"新浪微博";
        }
        if ([handleName isEqualToString:DDPlatformHandleQQ]) {
            platformID = @"com.tencent.mqq.ShareExtension";
            tipPlatform = @"QQ";
        }
        if ([handleName isEqualToString:DDPlatformHandleWechat]) {
            platformID = @"com.tencent.xin.sharetimeline";
            tipPlatform = @"微信";
        }
        if ([handleName isEqualToString:DDPlatformHandleAlipay]) {
            platformID = @"com.alipay.iphoneclient.ExtensionSchemeShare";
            tipPlatform = @"支付宝";
        }
        if ([handleName isEqualToString:DDPlatformHandleTwitter]) {
            platformID = @"com.apple.share.Twitter.post";
            tipPlatform = @"推特";
        }
        if ([handleName isEqualToString:DDPlatformHandleFacebook]) {
            platformID = @"com.apple.share.Facebook.post";
            tipPlatform = @"脸书";
        }
        if ([handleName isEqualToString:DDPlatformHandleInstagram]) {
            platformID = @"com.burbn.instagram.shareextension";
            tipPlatform = @"instagram";
        }
        if ([handleName isEqualToString:DDPlatformHandleNotes]) {
            platformID = @"com.apple.mobilenotes.SharingExtension";
            tipPlatform = @"备忘录";
        }
        if ([handleName isEqualToString:DDPlatformHandleReminders]) {
            platformID = @"com.apple.reminders.RemindersEditorExtension";
            tipPlatform = @"提醒事项";
        }
        if ([handleName isEqualToString:DDPlatformHandleiCloud]) {
            platformID = @"com.apple.mobileslideshow.StreamShareService";
            tipPlatform = @"iCloud";
        }
        
        /********************************end*************************************************/
        
        NSString *UNLoginTip = [NSString stringWithFormat:@"没有配置%@相关的帐号",tipPlatform];
        NSString *UNInstallTip = [NSString stringWithFormat:@"没有安装%@",tipPlatform];
        
        SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:platformID];
        if (composeVc == nil){
            ALERT_MSG(@"提示",UNInstallTip,_presentVC);
            return;
        }
        if (![SLComposeViewController isAvailableForServiceType:platformID]) {
            ALERT_MSG(@"提示",UNLoginTip,_presentVC);
            return;
        }
        if (_shareText) [composeVc setInitialText:_shareText];
        if (_shareImage) [composeVc addImage:_shareImage];
        if (_shareUrl) [composeVc addURL:_shareUrl];
        
        [_presentVC presentViewController:composeVc animated:YES completion:nil];
        composeVc.completionHandler = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"点击了取消");
            } else {
                NSLog(@"点击了发送");
            }
        };
        
    };
    return handle;
}

- (void)sendmailTO:(NSString *)email
{
    if (![MFMailComposeViewController canSendMail]) {
        ALERT_MSG(@"提示",@"手机未设置邮箱",_presentVC);
        return;
    }
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller setToRecipients:@[email]];
    if (_shareText) {
        [controller setSubject:_shareText];
    }
    if (_shareUrl) {
        [controller setMessageBody:[NSString stringWithFormat:@"%@",_shareUrl] isHTML:YES];
    }
    if (_shareImage) {
        NSData *imageData = UIImagePNGRepresentation(_shareImage);
        [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"图片.png"];
    }
    
    [controller setMailComposeDelegate:self];
    
    [_presentVC presentViewController:controller animated:YES completion:nil];
}

- (void)sendMessageTO:(NSString *)phoneNum{
    
    if(![MFMessageComposeViewController canSendText] ){
        ALERT_MSG(@"提示",@"设备不能发短信",_presentVC);
        return;
    }
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    [controller setRecipients:@[phoneNum]];
    NSString *bodySting = @"";
    if (_shareText) [bodySting stringByAppendingString:_shareText];
    if (_shareUrl) [bodySting stringByAppendingString:[NSString stringWithFormat:@"%@",_shareUrl]];
    controller.messageComposeDelegate =self;
    
    [_presentVC presentViewController:controller animated:YES completion:nil];;
    
}

#pragma mark - 邮件、短息代理方法

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [_presentVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [_presentVC dismissViewControllerAnimated:YES completion:nil];
}


@end
