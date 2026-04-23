import subprocess

def run_step(script):
    print(f"Running {script}")
    subprocess.run(["python3", script], check=True)

steps = [
    "scripts/load_data.py",
    "scripts/preprocess.py",
    "scripts/feature_engineering.py"
]

for s in steps:
    run_step(s)
print("Pipeline complete")