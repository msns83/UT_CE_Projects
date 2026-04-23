
import subprocess

def run_step(script):
    print(f"\nRunning {script}\n")
    subprocess.run(["python3", script], check=True)

steps = [
    "scripts/load_data.py",
    "scripts/preprocess.py",
    "scripts/feature_engineering.py",
    "scripts/train_model.py",
    "scripts/make_predictions.py"
]

for s in steps:
    run_step(s)
print("Full pipeline complete.\n")
