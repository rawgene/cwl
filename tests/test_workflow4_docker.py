import subprocess
import filecmp

def test_workflow4_docker():
    subprocess.run(["cwl-runner",
                    "--outdir=./test_workflow4",
                    "./workflows/salmon_DESeq2.cwl",
                    "./workflows/salmon_DESeq2.yml"])
    assert filecmp.cmp("./test_workflow4/DESeq2/untreated-treated_DGE_res.csv",
                        "./tests/DGE_res.salmon_deseq2.csv")
    assert filecmp.cmp("./test_workflow4/salmon_count/gene_count_matrix.csv",
                        "./tests/salmon_gene_count.csv")

if __name__ == "__main__":
    test_workflow4_docker()
