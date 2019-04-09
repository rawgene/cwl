import subprocess
import filecmp

def test_workflow3_docker():

    subprocess.run(["cwl-runner",
                    "--outdir=./test_workflow3",
                    "./workflows/hisat2_cufflink_cuffmerge_cuffquant_ballgown.cuffdiffs.cwl",
                    "./workflows/hisat2_cufflink_cuffmerge_cuffquant_ballgown.cuffdiffs.yml"])

    assert filecmp.cmp("./test_workflow3/ballgown/untreated-treated_DGE_res.csv",
                        "./tests/DGE_res.hisat2_ballgown.csv")


if __name__ == "__main__":
    test_workflow3_docker()
