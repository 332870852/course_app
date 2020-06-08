# 毕业设计——智慧课堂辅助APP的设计与实现 (禁止侵权)
## 背景
移动互联网技术日新月异，智慧课堂类的教育软件层出不穷，开发者们利用手机普 及、随身携带的特点开发出了许多课堂类的使用软件，使用这类软件，人们可以在网络 上完成课堂考勤、课堂测试等辅助类教学工作[4]。这些课堂软件它们存在各自的优点但 与此同时也存在着缺陷和不足。如今，一种移动跨平台应用技术，可以使人们在不同设 备上体验到一致的课堂应用，不必在众多不同软件之间做出选择或组合使用，可以大大 提高课堂效率和获得良好的线上教学体验。近几年移动跨平台技术已经得到快速发展， 结合移动跨平台技术已经在计算机服务和移动应用上取得辉煌的成绩。目前，随着移动 跨平台技术的不断完善和成熟，移动应用技术已经有了越来越广泛的应用和落地场景 [4]。跨平台的应用场景包括了教育、生活、娱乐和社交等各个类型的应用领域，利用 这些技术已能实现在 PC、手机、嵌入式等设备上，体验到同一个应用系统提供的一致性服务，不仅提高了开发过程的效率问题，节省了成本的同时，软件的使用方式也变得更 便捷。移动设备已经成为人们日常生活中必不可少的工具，通过手机 App 能够为用户提 供许多方便快捷的服务。
# course_app
智慧课堂辅助 App 结合了移动跨平台技术，系统由 APP 和 APP 后台管理系统 组成。系统服务端使用 Java 编程语言，采用SSH+Netty+Redis+FastDFS+RabbitMQ 框架设计。App 系统主要分用户模块、课堂模块、聊天模块和后台管理模块四部 分，实现了公告、话题、资料、考勤、作业、成绩、聊天等功能。各功能的查询 业务中引入了 Redis 实现对数据的分页缓存；课堂资料管理以及私信模块的文件 使用 FastDFS 分布式文件系统完成了对文件的存储；考勤、公告等子模块中使用 了 Websocket 与 RabbitMQ 消息队列实现业务纵向解耦和数据实时推送；聊天模 块则采用了 Netty 提供的 NIO 框架进行设计，利用 WebRtc 实现了音视频实时通 迅。APP 和管理后台网站都是基于 Flutter 跨平台框架完成设计。客户端可以打 包成 APP 和 Web 程序，运行在手机、ipad、电脑等设备上，并拥有一致的 UI 体 验。

# 部分UI展示(图片在display文件夹)
## APP
![Image text](https://github.com/332870852/course_app/blob/master/display/login.jpg)
![Image text](https://github.com/332870852/course_app/blob/master/display/classroom.jpg)
![Image text](https://github.com/332870852/course_app/blob/master/display/index.jpg)
![Image text](https://github.com/332870852/course_app/blob/master/display/share.png)
## Web
![Image text](https://github.com/332870852/course_app/blob/master/display/admin1.png)
![Image text](https://github.com/332870852/course_app/blob/master/display/admin2.png)
#成果
![Image text](https://github.com/332870852/course_app/blob/master/display/chengguo.png)
![Image text](https://github.com/332870852/course_app/blob/master/display/share.png)

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
