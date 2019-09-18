FROM n0trace/anyproxy

EXPOSE 8001 8002

ENTRYPOINT ["anyproxy", "--intercept"]
