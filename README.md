# anyproxy in docker
## Quickly Run
```
docker run --name anyproxy --restart=always \
    -p 8001:8001\
    -p 8002:8002 \
    -d zrbcool/anyproxy:latest
```
access [ip]:8002 in your browser
![](http://oss.zrbcool.top/picgo/anyproxy-1.png-gh)

### Apache Httpclient Support & Configuration
#### For Apache HttpClient 4.5+ & Java8
```java
SSLContext sslContext = SSLContexts.custom()
        .loadTrustMaterial((chain, authType) -> true).build();

SSLConnectionSocketFactory sslConnectionSocketFactory =
        new SSLConnectionSocketFactory(sslContext, new String[]
        {"SSLv2Hello", "SSLv3", "TLSv1","TLSv1.1", "TLSv1.2" }, null,
        NoopHostnameVerifier.INSTANCE);
CloseableHttpClient client = HttpClients.custom()
        .setSSLSocketFactory(sslConnectionSocketFactory)
	.setProxy(new HttpHost('$proxyHost', '$proxyPort'))//important! replace $proxyHost and $proxyPort with your real value
        .build();
```
#### But if your HttpClient use a ConnectionManager
But if your HttpClient use a ConnectionManager for seeking connection, e.g. like this:
```java
 PoolingHttpClientConnectionManager connectionManager = new 
         PoolingHttpClientConnectionManager();

 CloseableHttpClient client = HttpClients.custom()
            .setConnectionManager(connectionManager)
            .build();
```
The HttpClients.custom().setSSLSocketFactory(sslConnectionSocketFactory) has no effect, the problem is not resolved.  

Because that the HttpClient use the specified connectionManager for seeking connection and the specified connectionManager haven't register our customized SSLConnectionSocketFactory. To resolve this, should register the The customized SSLConnectionSocketFactory in the connectionManager. The correct code should like this:  
```java
PoolingHttpClientConnectionManager connectionManager = new 
    PoolingHttpClientConnectionManager(RegistryBuilder.
                <ConnectionSocketFactory>create()
      .register("http",PlainConnectionSocketFactory.getSocketFactory())
      .register("https", sslConnectionSocketFactory).build());

CloseableHttpClient client = HttpClients.custom()
            .setConnectionManager(connectionManager)
            .build();
```
### Chrome / Android / IOS / OSX
please refer to offical document:  
[http://anyproxy.io/](http://anyproxy.io/)
