# Generate Normal CPU Values
import numpy as np
import pandas as pd

np.random.seed(42)

normal_cpu = np.random.normal(
    loc=50,
    scale=5,
    size=200
)

anomalies = np.array([
    85, 90, 95, 92, 88
])

cpu = np.concatenate([normal_cpu, anomalies])

df = pd.DataFrame({
    "cpu_usage": cpu
})

print(df.tail(10))


# Introduce Isolation Forest
from sklearn.ensemble import IsolationForest

model = IsolationForest(
    contamination=0.05,
    random_state=42
)

model.fit(df[["cpu_usage"]])



# Detect anomalies:

df["prediction"] = model.predict(
    df[["cpu_usage"]]
)

anomalies_found = df[
    df["prediction"] == -1
]

print("Anomalies detected:")
print(anomalies_found)




# Turn Delection into AIOps Alert
if not anomalies_found.empty:
    print("\nAIOPS ALERT")
    print(
        f"{len(anomalies_found)} "
        "anomalous observations detected."
    )


# Visualize the anomalies [Report]
print("\n" + "=" * 50)
print("           AIOPS ANOMALY REPORT")
print("=" * 50)

print(f"Total observations : {len(df)}")
print(f"Anomalies detected : {len(anomalies_found)}")

print("\nDetected Anomalies:")
print("-" * 50)

for index, row in anomalies_found.iterrows():
    print(
        f"Observation {index:3} | "
        f"CPU: {row['cpu_usage']:.2f}% | "
        f"Status: ANOMALY"
    )

print("\n" + "=" * 50)
print("AIOPS ALERT")
print("=" * 50)

if not anomalies_found.empty:
    print(
        f"WARNING: {len(anomalies_found)} "
        "anomalous observations detected!"
    )
else:
    print("System operating normally.")

print("=" * 50)
