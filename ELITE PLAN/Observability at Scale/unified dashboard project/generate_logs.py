import requests
import time
import json

logs = [
    ("aws", "checkout", "INFO", "Checkout request processed"),
    ("aws", "checkout", "ERROR", "Database timeout"),
    ("azure", "checkout", "INFO", "Checkout request processed"),
    ("azure", "payment", "ERROR", "Payment gateway timeout"),
    ("gcp", "checkout", "INFO", "Checkout request processed"),
    ("gcp", "payment", "ERROR", "Payment API returned 500"),
]

for cloud, service, level, message in logs:

    timestamp = str(int(time.time() * 1_000_000_000))

    payload = {
        "streams": [
            {
                "stream": {
                    "cloud": cloud,
                    "service": service,
                    "environment": "production",
                    "level": level.lower()
                },
                "values": [
                    [
                        timestamp,
                        json.dumps({
                            "message": message
                        })
                    ]
                ]
            }
        ]
    }

    response = requests.post(
        "http://localhost:3100/loki/api/v1/push",
        json=payload
    )

    print(cloud, service, response.status_code)
