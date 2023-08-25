    [OUTPUT]
        Name es
        Match kube.*
        Host kang-elastic-es-http.default
        Logstash_Format On
        Logstash_Prefix monitoring
        Index monitoring
        Time_Key @timestamp
        Retry_Limit False
        HTTP_User elastic
        HTTP_Passwd Q36WMBc851R4Jx5HQW5Qm53I
        tls On
        tls.verify Off
        Replace_Dots    On
        Suppress_Type_Name On
    

    [OUTPUT]
        Name es
        Match host.*
        Host kang-elastic-es-http.default
        Logstash_Format On
        Logstash_Prefix node
        Retry_Limit False
        HTTP_User elastic
        HTTP_Passwd Q36WMBc851R4Jx5HQW5Qm53I
        tls On
        tls.verify Off
        Replace_Dots    On
        Suppress_Type_Name On



#        Kube_URL https://kubernetes.default.svc:443
#        Kube_Token_File /var/run/secrets/kubernetes.io/serviceaccount/token
#        Kube_CA_File /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
#        tls.verify off
#        Labels on
#        Annotations on