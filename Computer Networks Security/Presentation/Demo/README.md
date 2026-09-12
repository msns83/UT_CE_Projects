# DNS exfiltration and detection prototype

This folder contains a safe classroom prototype based on the paper
"Real-Time Detection of DNS Exfiltration and Tunneling from Enterprise
Networks."

It demonstrates:

- **Attack:** encode a harmless message into DNS-looking subdomain strings.
- **Receiver:** rebuild the message from those strings.
- **Defense:** extract the paper's eight features and use Isolation Forest to
  mark unusual query names.

The program is fully offline. It sends no DNS packets and needs no external
Python packages. Benign training/test names are loaded from the `data/`
directory.

## Run the demo

Use Python 3.10 or newer:

```bash
python3 src/main.py
```

Show every tested query:

```bash
python3 src/main.py --show-all
```

Save the results:

```bash
python3 src/main.py --save-csv demo_results.csv
```

Use values closer to the paper's reported tuning:

```bash
python3 src/main.py --paper-settings
```

This mode uses two trees, 18 samples, 2% contamination, and the paper's reported
0.54 score threshold. With a very small synthetic dataset, it can produce more
false alarms than the stable default. That difference is a useful discussion
point: model settings that work on one large real dataset do not automatically
work equally well on another dataset.

Use your own harmless message:

```bash
python3 src/main.py --message "This is our classroom demonstration."
```

Use only the benign domain text files:

```bash
python3 src/main.py --benign-source text
```

Use only DNS query names extracted from the PCAP files:

```bash
python3 src/main.py --benign-source pcap
```

Change the training/test split:

```bash
python3 src/main.py --train-count 1200 --test-count 200
```

## Files

- `src/main.py`: command-line demo runner.
- `src/attack.py`: attack simulation and message reconstruction.
- `src/defence.py`: feature extraction plus anomaly detection wrapper.
- `src/model.py`: small educational Isolation Forest.
- `src/data.py`: DNS feature extraction and benign dataset loaders.
- `src/result.py`: printed tables, metrics, and CSV output.
- `data/domains_*.txt`: benign domain names.
- `data/*.pcap`: benign packet captures; DNS query names are extracted when
  `--benign-source auto`, `both`, or `pcap` is used.
- `presentation/PAPER_EXPLANATION.md`: easy-English explanation and
  presentation plan.

## Important presentation note

The default demo uses 100 trees and 64 samples per tree because this gives more
stable results on our small synthetic dataset. The `--paper-settings` option
uses two trees, 18 samples, and the reported 0.54 threshold.

The paper used real enterprise traffic, scikit-learn, and about 1.4 million
generated malicious DNS queries. Our code is intentionally smaller and safer;
it reproduces the central idea rather than the full production experiment.
