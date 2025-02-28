# THU LLM Proxy Gateway

清华大模型反代
> 你清有了自己的 DeepSeek 实例，但是限制校园网登陆，于是便有了本项目。  

## ✨ Features 
- 🔁 Reverse proxy for campus-only LLM APIs
- 🚀 Stream response optimization (filter empty chunks)
- - [ ] 🔒 Safety features (IP whitelist)


## ⚙️ Configuration
Create `.env` file:
```
PROXY_PORT=11443

HOST_ADDRESS=api.example.com

UPSTREAM_ENDPOINT=https://madmodel.cs.tsinghua.edu.cn
```

## 🚀 Deployment
```
# 1. Clone repository
git clone https://github.com/yourname/thu-llm-proxy
cd thu-llm-proxy

# 2. Build and start
docker-compose up -d --build

# 3. Verify
curl -v -x POST http://localhost:${PROXY_PORT}/v1/chat/completions
```

## 🌐 Usage
```
curl --location -X POST 'http://api.example.com:11443/v1/chat/completions' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <YOUR_TOKEN>' \
-d '{
  "model": "DeepSeek-R1-Distill-32B",
  "messages": [
    { "role": "user", "content": "Only Say Yes" }
  ],
  "stream": true
}'
```

## ⚠️ Disclaimer
**For Technical Study Only 仅供技术研究**  
This project is intended for educational purposes in network programming and reverse proxy implementations. The maintainers do not encourage nor endorse bypassing institutional network policies. Use at your own risk.

## 📜 License
MIT
