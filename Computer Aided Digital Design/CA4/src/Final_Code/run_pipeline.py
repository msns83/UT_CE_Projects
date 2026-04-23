import argparse
import os
import subprocess
import sys
from pathlib import Path


def _run(cmd: list[str], cwd: Path) -> None:
    print(f"[run] cwd={cwd} :: {' '.join(cmd)}")
    try:
        subprocess.run(cmd, cwd=str(cwd), check=True)
    except FileNotFoundError as e:
        raise SystemExit(
            f"Command not found: {cmd[0]}\n"
            f"Make sure it is installed and on PATH.\n"
            f"Original error: {e}"
        )
    except subprocess.CalledProcessError as e:
        raise SystemExit(f"Command failed (exit {e.returncode}): {' '.join(cmd)}")


def main() -> None:
    here = Path(__file__).resolve()
    final_code_dir = here.parent
    ca4_src_dir = final_code_dir.parent
    ca4_dir = ca4_src_dir.parent

    default_yosys_dir = ca4_src_dir / "Yosys_Code"
    default_yosys_script = default_yosys_dir / "lut2synthesis.ys"
    default_yosys_out = default_yosys_dir / "synthesized_top.v"

    default_mapper = final_code_dir / "lut2mapper.py"

    ap = argparse.ArgumentParser(
        description="Run CA4 pipeline: Yosys synth -lut 2, then lut2mapper."
    )
    ap.add_argument(
        "--yosys",
        default="yosys",
        help="Yosys executable name/path (default: yosys)",
    )
    ap.add_argument(
        "--yosys-dir",
        default=str(default_yosys_dir),
        help="Directory where the yosys script runs (default: CA4/src/Yosys_Code)",
    )
    ap.add_argument(
        "--yosys-script",
        default=str(default_yosys_script),
        help="Path to yosys .ys script (default: CA4/src/Yosys_Code/lut2synthesis.ys)",
    )
    ap.add_argument(
        "--yosys-out",
        default=str(default_yosys_out),
        help="Expected yosys output netlist (default: CA4/src/Yosys_Code/synthesized_top.v)",
    )
    ap.add_argument(
        "--mapper",
        default=str(default_mapper),
        help="Path to lut2mapper.py (default: CA4/src/Final_Code/lut2mapper.py)",
    )
    ap.add_argument(
        "--cell",
        choices=["c1", "c2"],
        default="c2",
        help="Which combinational cell to map LUTs into (default: c2)",
    )
    ap.add_argument(
        "--count-cells",
        action="store_true",
        help="Generate modules.v with cell-counting $system calls enabled",
    )

    args = ap.parse_args()

    yosys_dir = Path(args.yosys_dir).resolve()
    yosys_script = Path(args.yosys_script).resolve()
    yosys_out = Path(args.yosys_out).resolve()
    mapper = Path(args.mapper).resolve()

    if not yosys_script.exists():
        raise SystemExit(f"Yosys script not found: {yosys_script}")
    if not mapper.exists():
        raise SystemExit(f"Mapper not found: {mapper}")

    # 1) Run yosys
    _run([args.yosys, "-s", str(yosys_script)], cwd=yosys_dir)

    if not yosys_out.exists():
        raise SystemExit(
            "Yosys finished, but expected output netlist was not found: "
            f"{yosys_out}\n"
            "Check the write_verilog line in the .ys script."
        )

    # 2) Run mapper
    mapper_cmd = [
        sys.executable,
        str(mapper),
        str(yosys_out),
        "--cell",
        args.cell,
    ]
    if args.count_cells:
        mapper_cmd.append("--count-cells")

    # Run mapper in Final_Code so outputs land next to modules.v
    _run(mapper_cmd, cwd=final_code_dir)

    mapped_netlist = final_code_dir / f"mapped_{yosys_out.name}"
    modules_v = final_code_dir / "modules.v"

    print("\n[ok] Pipeline complete")
    print(f"- Yosys netlist: {yosys_out}")
    print(f"- Mapped netlist: {mapped_netlist}")
    print(f"- Modules: {modules_v}")


if __name__ == "__main__":
    main()
