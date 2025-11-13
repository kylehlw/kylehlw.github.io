Production Level **IoT** Fundations

Features.

1. Cluster, reliability with failure over.
2. Load testing support large scale.
3. Data Encryption.
4. Proper client authentication.

In order to support above features to fully enable production level IoT Services (foundation of FMS), investigation of TLS/**SSL** support in RabbitMQ is needed.

# TLS Basics

[**TLS Support - RabbitMQ**](https://www.rabbitmq.com/docs/ssl#certificates-and-keys)

Some basic notes.

[Transport Layer Security](https://www.google.com/search?sca_esv=148cca40eee112c3&sxsrf=AE3TifN4-a-7LiZPllth-HWd9LYYfG7m6Q%3A1758851684901&q=Transport+Layer+Security&sa=X&ved=2ahUKEwi_q5CPqfWPAxU44zgGHQBzErcQxccNegQIMxAB&mstk=AUtExfBUzmPgVKLryFs1Y6VYrM1PSr7Kdz0EdjCdlZ0jhgNbGOqUshYAxd1lEsN5niH8qLh3S7Mr8BZkr1VC9J8HOTQ0CDro37EpYzPGbXxsKZvUcpeDGuMkeG_yZvOjUJnBzuhZelil77hyunimMfSdonb1ep7PUHBKpEdybEmVAX04rCKPhhgL6RqYT1S1IGFLRQXvBq5LbPBEkhqzfYcPHAjl7nm9D8mwAdm9LI-yC7f6dMZTyUsedkMbyCgwWVGykVGeVndrcP2N8JXYu5drSr1q&csui=3 "https://www.google.com/search?sca_esv=148cca40eee112c3&sxsrf=AE3TifN4-a-7LiZPllth-HWd9LYYfG7m6Q%3A1758851684901&q=Transport+Layer+Security&sa=X&ved=2ahUKEwi_q5CPqfWPAxU44zgGHQBzErcQxccNegQIMxAB&mstk=AUtExfBUzmPgVKLryFs1Y6VYrM1PSr7Kdz0EdjCdlZ0jhgNbGOqUshYAxd1lEsN5niH8qLh3S7Mr8BZkr1VC9J8HOTQ0CDro37EpYzPGbXxsKZvUcpeDGuMkeG_yZvOjUJnBzuhZelil77hyunimMfSdonb1ep7PUHBKpEdybEmVAX04rCKPhhgL6RqYT1S1IGFLRQXvBq5LbPBEkhqzfYcPHAjl7nm9D8mwAdm9LI-yC7f6dMZTyUsedkMbyCgwWVGykVGeVndrcP2N8JXYu5drSr1q&csui=3"), is a cryptographic protocol that provides end-to-end data security and privacy over computer networks like the internet.

SSL, or [Secure Sockets Layer](https://www.google.com/search?sca_esv=148cca40eee112c3&cs=0&sxsrf=AE3TifMabmM35DiRuY_x4ygxIfZZp-EJLw%3A1758851701842&q=Secure+Sockets+Layer&sa=X&ved=2ahUKEwj0lfCWqfWPAxXyoWMGHbkIAX4QxccNegQIAxAB&mstk=AUtExfC4alaOwnuDt6CYDyKzXMdNNFmZk_Z61wSEYagdfzwoqn8KryUnwyMQ-zMeve8GuqPAjfRK_GWW1a8jN4vUL5VqmJNm5jmSaHi-xg4T6X3YtrCKlc9dUXzxPWIPtxm84er8wBVxdQAjozroaVr72vqdGZwme7WnVu5HjsWdgff09PzugTkYOjKloetbhycF_-jYLw1QQvq32yp0AV6clvm-c8fLyGHgoKin6aD023s8dmLvMpBL84NUw8Wq1Am_ZG51OC9Nzv14CB7_HXh0qc4b&csui=3 "https://www.google.com/search?sca_esv=148cca40eee112c3&cs=0&sxsrf=AE3TifMabmM35DiRuY_x4ygxIfZZp-EJLw%3A1758851701842&q=Secure+Sockets+Layer&sa=X&ved=2ahUKEwj0lfCWqfWPAxXyoWMGHbkIAX4QxccNegQIAxAB&mstk=AUtExfC4alaOwnuDt6CYDyKzXMdNNFmZk_Z61wSEYagdfzwoqn8KryUnwyMQ-zMeve8GuqPAjfRK_GWW1a8jN4vUL5VqmJNm5jmSaHi-xg4T6X3YtrCKlc9dUXzxPWIPtxm84er8wBVxdQAjozroaVr72vqdGZwme7WnVu5HjsWdgff09PzugTkYOjKloetbhycF_-jYLw1QQvq32yp0AV6clvm-c8fLyGHgoKin6aD023s8dmLvMpBL84NUw8Wq1Am_ZG51OC9Nzv14CB7_HXh0qc4b&csui=3"), is an encryption protocol that creates a secure, encrypted connection between a client (like a web browser) and a server (like a website).

TLS is the modern, upgraded successor to the outdated [SSL protocol](https://www.google.com/search?sca_esv=148cca40eee112c3&cs=0&sxsrf=AE3TifNDHVo8AMb4WGzOjS3dX_v5JTrF8w%3A1758851728268&q=SSL+protocol&sa=X&ved=2ahUKEwjonOejqfWPAxUIxjgGHUE2A2kQxccNegQIIRAB&mstk=AUtExfCrOWBSAGEtTUSY9VBFSKWrREJ_svIFPHDuULKw26ehzl59TXAkMxgnWWawl5x93_oj_LCCDH_HT4SEfC7TUrnsO9OgsjFPH8OQoiprSd7S8yoXxXVTjREfiv2Q0PSnl9QrqA7DwDP2GPS64Sa4aajAIuj6E4uxvc_p01yxVYcVh_jEwEiwxs85fT8Er2kZC0htUhkxOzhEJyypGXDiYNmgyGV3mZswwnjQdwbEzBzNnt4zRYEo1KxZTvY5glqqouoUUkRW-g5BVIvQyzDJx_Gf&csui=3 "https://www.google.com/search?sca_esv=148cca40eee112c3&cs=0&sxsrf=AE3TifNDHVo8AMb4WGzOjS3dX_v5JTrF8w%3A1758851728268&q=SSL+protocol&sa=X&ved=2ahUKEwjonOejqfWPAxUIxjgGHUE2A2kQxccNegQIIRAB&mstk=AUtExfCrOWBSAGEtTUSY9VBFSKWrREJ_svIFPHDuULKw26ehzl59TXAkMxgnWWawl5x93_oj_LCCDH_HT4SEfC7TUrnsO9OgsjFPH8OQoiprSd7S8yoXxXVTjREfiv2Q0PSnl9QrqA7DwDP2GPS64Sa4aajAIuj6E4uxvc_p01yxVYcVh_jEwEiwxs85fT8Er2kZC0htUhkxOzhEJyypGXDiYNmgyGV3mZswwnjQdwbEzBzNnt4zRYEo1KxZTvY5glqqouoUUkRW-g5BVIvQyzDJx_Gf&csui=3"), offering enhanced security, improved algorithms, and better performance through more efficient handshakes and stronger encryption standards. While often used interchangeably, the key distinction is that SSL is the original, deprecated protocol with known vulnerabilities, whereas TLS is the current, secure, and recommended standard for encrypted communication online.

**Improvements:**

* **Stronger Encryption:** Uses stronger algorithms like **AES** and collision-resistant hashing algorithms like SHA-256.
* **Better Security:** Includes features like Hash-based Message Authentication Codes (HMACs) to ensure data integrity and prevent tampering.
* **Faster Handshake:** The handshake process to establish a secure connection is more efficient and takes fewer steps.

# Quick RabbitMQ / **MQTT** TLS setup for encryption and authentication Test

Shortcut for cert generation

[**tls-gen/basic at main · rabbitmq/tls-gen**](https://github.com/rabbitmq/tls-gen/tree/main/basic)

## Certification Setup

1. Create Root CA Key Pair (Private Key and ca_certificate)

   ```
   openssl genrsa -des3 -out ca.key 2048
   openssl req -new -x509 -days 1826 -key ca.key -out ca.crt
   ```
2. Setup Server certificate and sign with Root CA Key Pair

   ```
   openssl genrsa -out server.key 2048
   openssl req -new -out server.csr -key server.key
   openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CA createserial -out server.crt -days 360
   ```
3. Setup Client cert and sign with Root CA Key Pair.

   ```
   openssl genrsa -out client.key 2048
   openssl req -new -out client.csr -key client.key
   openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 360
   ```

Setup RabbitMQ with Server Cert

Distribute ca_certificate.pem (public key) and client key pair for client to use.

## Cert Distribution Diagram

![cert_distribution](../assets/img/2025-09-26_TLS_1.png )


## Client Cert Generation Key Concept

When generate client cert, can customize the cert sign request configurations to have different distributed name, other names, uri etc, used for identify the client.

## Sample RabbitMQ Server Config

```
mqtt.allow_anonymous = false
anonymous_login_user = none

ssl_options.cacertfile = /etc/rabbitmq/certs/ca_certificate.pem
ssl_options.certfile   = /etc/rabbitmq/certs/server_rabbit.local_certificate.pem
ssl_options.keyfile    = /etc/rabbitmq/certs/server_rabbit.local_key.pem
ssl_options.verify     = verify_peer
ssl_options.fail_if_no_peer_cert = false

# default TLS-enabled port for MQTT connections
mqtt.listeners.ssl.default = 8883
mqtt.listeners.tcp.default = 1883
mqtt.ssl_cert_login = true
ssl_cert_login_from = common_name
# mqtt.ssl_cert_client_id_from = subject_alternative_name
# mqtt.ssl_cert_login_san_type = other_name
```

Here we disabled the client id verification with cert based authentication, reason will be explained.

## Sample Client

Sub

```
mosquitto_sub -h rabbit.local -p 8883 -t "test" --cafile ca_certificate.pem --cert APM0001.pem --key APM0001.key -i APM0001 -V mqttv5 --property CONNECT user-property client_type APM
```

Pub

```
mosquitto_pub -h rabbit.local -p 8883 -t "test" --cafile ca_certificate.pem --cert APM0001.pem --key APM0001.key -i APM0001_pub -m "hello"
```

## Key Note

**Unique Client ID verification**

MQTT only allow one client_id has only one connection, client with same id will kick out the original one.

MQTT cert authentication can support client_id verification, in this the client must use the client id as the same as the configured cert subject name, e.g. in above server config, the comment out part means client_id will be extracted from cert by SAN, otherName, if the client_id doesn’t match
But this also means, with one cert, only one client_id can be used with that given cert. This won’t be suitable for applications that may need multiple MQTT connections with the same broker.

So, very likely, we will disable the client_id verification.

**Port for TLS**

When use cert authentication, must also use the encrypted protocol, by default in RabbitMQ plugin, running over 8883 port

**Example of How to configure User Property with mqtt5.0**

```
mosquitto_sub -h rabbit.local -p 8883 -t "test" --cafile ca_certificate.pem --cert APM0001.pem --key APM0001.key -i APM0001 -V mqttv5 --property CONNECT user-property client_type APM --property CONNECT user-property client_name APM0001 
```

```
curl -sL -u monitoring:monitoring -H "Accept: application/json" http://127.0.0.1:15672/api/connections | jq
```

```
[
  {
    "auth_mechanism": "none",
    "channel_max": 0,
    "client_properties": {
      "user_property": {
        "client_name": "APM0001",
        "client_type": "APM"
      },
      "client_id": "APM0001"
    },
    "connected_at": 1758882689171,
    "frame_max": 0,
    "garbage_collection": {
      "fullsweep_after": 65535,
      "max_heap_size": 0,
      "min_bin_vheap_size": 46422,
      "min_heap_size": 233,
      "minor_gcs": 16
    },
    "host": "127.0.0.1",
    "name": "127.0.0.1:56258 -> 127.0.0.1:8883",
    "node": "rabbit@kyle-laptop",
    "peer_cert_issuer": "L=$$$$,CN=TLSGenSelfSignedRootCA 2025-09-25T17:14:43.149810",
    "peer_cert_subject": "CN=rabbit.local,OU=Unit,O=Organization,L=City,ST=State,C=US",
    "peer_cert_validity": "2025-09-25T10:26:01Z - 2026-09-25T10:26:01Z",
    "peer_host": "127.0.0.1",
    "peer_port": 56258,
    "port": 8883,
    "protocol": "MQTT 5-0",
    "recv_cnt": 5,
    "recv_oct": 2697,
    "recv_oct_details": {
      "rate": 0
    },
    "reductions": 15903,
    "reductions_details": {
      "rate": 0
    },
    "send_cnt": 4,
    "send_oct": 2741,
    "send_oct_details": {
      "rate": 0
    },
    "send_pend": 0,
    "ssl": true,
    "ssl_cipher": "aes_256_gcm",
    "ssl_hash": "aead",
    "ssl_key_exchange": "any",
    "ssl_protocol": "tlsv1.3",
    "state": "running",
    "timeout": 60,
    "user": "rabbit.local",
    "user_who_performed_action": "rabbit.local",
    "vhost": "/"
  }
]
```
