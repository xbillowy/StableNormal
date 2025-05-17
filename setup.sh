XFORMERS=true

# Get system information
WORKDIR=$(pwd)
PYTORCH_VERSION=$(python -c "import torch; print(torch.__version__)")
PYTORCH_VERSION=${PYTORCH_VERSION%%+*}
PLATFORM=$(python -c "import torch; print(('cuda' if torch.version.cuda else ('hip' if torch.version.hip else 'unknown')) if torch.cuda.is_available() else 'cpu')")
case $PLATFORM in
    cuda)
        CUDA_VERSION=$(python -c "import torch; print(torch.version.cuda)")
        CUDA_MAJOR_VERSION=$(echo $CUDA_VERSION | cut -d'.' -f1)
        CUDA_MINOR_VERSION=$(echo $CUDA_VERSION | cut -d'.' -f2)
        echo "[SYSTEM] PyTorch Version: $PYTORCH_VERSION, CUDA Version: $CUDA_VERSION"
        ;;
    hip)
        HIP_VERSION=$(python -c "import torch; print(torch.version.hip)")
        HIP_MAJOR_VERSION=$(echo $HIP_VERSION | cut -d'.' -f1)
        HIP_MINOR_VERSION=$(echo $HIP_VERSION | cut -d'.' -f2)
        # Install pytorch 2.4.1 for hip
        if [ "$PYTORCH_VERSION" != "2.4.1+rocm6.1" ] ; then
        echo "[SYSTEM] Installing PyTorch 2.4.1 for HIP ($PYTORCH_VERSION -> 2.4.1+rocm6.1)"
            pip install torch==2.4.1 torchvision==0.19.1 --index-url https://download.pytorch.org/whl/rocm6.1 --user
            mkdir -p /tmp/extensions
            sudo cp /opt/rocm/share/amd_smi /tmp/extensions/amd_smi -r
            cd /tmp/extensions/amd_smi
            sudo chmod -R 777 .
            pip install .
            cd $WORKDIR
            PYTORCH_VERSION=$(python -c "import torch; print(torch.__version__)")
        fi
        echo "[SYSTEM] PyTorch Version: $PYTORCH_VERSION, HIP Version: $HIP_VERSION"
        ;;
    *)
        ;;
esac

if [ "$XFORMERS" = true ] ; then
    # Install xformers
    if [ "$PLATFORM" = "cuda" ] ; then
        if [ "$CUDA_VERSION" = "11.8" ] ; then
            case $PYTORCH_VERSION in
                2.0.1) pip install "https://files.pythonhosted.org/packages/52/ca/82aeee5dcc24a3429ff5de65cc58ae9695f90f49fbba71755e7fab69a706/xformers-0.0.22-cp310-cp310-manylinux2014_x86_64.whl" ;;
                2.1.0) pip install "xformers==0.0.22.post7" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.1.1) pip install "xformers==0.0.23" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.1.2) pip install "xformers==0.0.23.post1" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.2.0) pip install "xformers==0.0.24" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.2.1) pip install "xformers==0.0.25" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.2.2) pip install "xformers==0.0.25.post1" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.3.0) pip install "xformers==0.0.26.post1" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.3.1) pip install "xformers==0.0.27" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.4.0) pip install "xformers==0.0.27.post2" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.4.1) pip install "xformers==0.0.28" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.5.0) pip install "xformers==0.0.28.post2" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.6.0) pip install "xformers==0.0.29.post3" --index-url "https://download.pytorch.org/whl/cu118" ;;
                2.7.0) pip install "xformers==0.0.30" --index-url "https://download.pytorch.org/whl/cu118" ;;
                *) echo "[XFORMERS] Unsupported PyTorch & CUDA version: $PYTORCH_VERSION & $CUDA_VERSION" ;;
            esac
        elif [ "$CUDA_VERSION" = "12.1" ] ; then
            case $PYTORCH_VERSION in
                2.1.0) pip install "xformers==0.0.22.post7" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.1.1) pip install "xformers==0.0.23" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.1.2) pip install "xformers==0.0.23.post1" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.2.0) pip install "xformers==0.0.24" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.2.1) pip install "xformers==0.0.25" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.2.2) pip install "xformers==0.0.25.post1" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.3.0) pip install "xformers==0.0.26.post1" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.3.1) pip install "xformers==0.0.27" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.4.0) pip install "xformers==0.0.27.post2" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.4.1) pip install "xformers==0.0.28" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.5.0) pip install "xformers==0.0.28.post2" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.6.0) pip install "xformers==0.0.29.post3" --index-url "https://download.pytorch.org/whl/cu121" ;;
                2.7.0) pip install "xformers==0.0.30" --index-url "https://download.pytorch.org/whl/cu121" ;;
                *) echo "[XFORMERS] Unsupported PyTorch & CUDA version: $PYTORCH_VERSION & $CUDA_VERSION" ;;
            esac
        elif [ "$CUDA_VERSION" = "12.4" ] ; then
            case $PYTORCH_VERSION in
                2.5.0) pip install "xformers==0.0.28.post2" --index-url "https://download.pytorch.org/whl/cu124" ;;
                2.6.0) pip install "xformers==0.0.29.post3" --index-url "https://download.pytorch.org/whl/cu124" ;;
                2.7.0) pip install "xformers==0.0.30" --index-url "https://download.pytorch.org/whl/cu124" ;;
                *) echo "[XFORMERS] Unsupported PyTorch & CUDA version: $PYTORCH_VERSION & $CUDA_VERSION" ;;
            esac
        else
            echo "[XFORMERS] Unsupported CUDA version: $CUDA_MAJOR_VERSION"
        fi
    elif [ "$PLATFORM" = "hip" ] ; then
        case $PYTORCH_VERSION in
            2.4.1\+rocm6.1) pip install "xformers==0.0.28" --index-url "https://download.pytorch.org/whl/rocm6.1" ;;
            *) echo "[XFORMERS] Unsupported PyTorch version: $PYTORCH_VERSION" ;;
        esac
    else
        echo "[XFORMERS] Unsupported platform: $PLATFORM"
    fi
fi

# Install other dependencies
pip install "gradio>=4.32.1"
pip install "gradio-imageslider>=0.0.20"
pip install pygltflib
pip install trimesh
pip install imageio
pip install imageio-ffmpeg
pip install Pillow
pip install einops
pip install spaces
pip install accelerate
pip install "diffusers>=0.28.0"
pip install matplotlib
pip install scipy
pip install torch
pip install transformers
