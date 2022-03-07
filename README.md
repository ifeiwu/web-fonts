# 网页字体

网页上应用到的字体非常少，例如 Window 默认是微软雅黑，如果要用上个性中文字体需要用户系统上安装。现在有很多开源免费商用中文字体，问题是体积很大，每个字体都要7、8MB或更大不利于网页下载。一般网页应用到的汉字不多，我们只需要压缩常用的汉字就能解决这个问题。

## 快速使用
##### 在 css 目录下选择要使用的字体，替换下面的 **字体目录** 和 **字体样式**
```
https://cdn.jsdelivr.net/gh/ifeiwu/web-fonts/css/字体目录/字体样式.css
```
##### 添加到页面

```html
<link href="https://cdn.jsdelivr.net/gh/ifeiwu/web-fonts/css/misans/misans.css" rel="stylesheet">
```

## 参考资源

[中文字体压缩的那些事](https://hsingko.github.io/post/compress_webfont/)