# WNS-windows推送服务 
## 环境
>1. powerbuilder9.0或以上
>2. 需要有uwp应用（并且关联商店）

## 说明
>1. pbl源码维护wnsservice_pbl，程序版本是Powerbuilder9.0。 
>2. 用户如果需要运行源码，请新建一个PBL命名wnsservice.pbl将源码文件导入。程序入口请在open事件中添加open(w_main)
>3. 配置文件是wnsconfig.ini文件。用户仅可以修改配置节点[wnsservice]下的配置值（accesstoken配置请勿修改）
>   >* 其中auth_url获取令牌的网址 
>   >* client_id是uwp应用的SID值 
>   >* client_secret是uwp应用密钥 
>   >* wns_url是wns服务的网址

