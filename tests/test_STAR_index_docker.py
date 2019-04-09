import subprocess
import filecmp

def test_STAR_index_docker():
    """test_STAR_index"""
    subprocess.run(["cwl-runner",
                    "--outdir=./test_STARIndex",
                    "./tools/STAR_index.cwl",
                    "./tools/STAR_index.yml"])

    assert filecmp.cmp("./tests/STARIndex/SA", "./test_STARIndex/STARIndex/SA")


if __name__ == "__main__":
    test_STAR_index_docker()
