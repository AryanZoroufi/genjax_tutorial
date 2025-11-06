#!/bin/bash
set -e

# Function to check if a directory exists and clone only if it doesn't
clone_if_not_exists() {
    local repo_url=$1
    local directory=$2
    
    # Check if we're in a git repository, if not, initialize one
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Not in a git repository, initializing..."
        git init
    fi
    
    # Check if directory already exists
    if [ -d "$directory" ]; then
        echo "Directory $directory already exists, skipping..."
    else
        echo "Cloning $repo_url to $directory..."
        git clone "$repo_url" "$directory"
        echo "Initializing and updating submodule recursively..."
        cd "$directory"
        git submodule update --init --recursive
        cd ..
    fi
}

# Function to download a file if it doesn't exist
download_if_not_exists() {
    local url=$1
    local filepath=$2
    
    if [ -f "$filepath" ]; then
        echo "File $filepath already exists, skipping download..."
    else
        echo "Downloading $url to $filepath..."
        wget -O $filepath $url --no-check-certificate
    fi
}

# Function to install requirements with error handling
install_requirements() {
    local requirements_file=$1
    echo "Installing requirements from $requirements_file..."
    if [ -f "$requirements_file" ]; then
        python -m pip install -r "$requirements_file" || echo "Warning: Some requirements failed to install from $requirements_file"
    else
        echo "Warning: $requirements_file not found"
    fi
}
pip install --upgrade --upgrade-strategy only-if-needed git+https://github.com/jinlinyi/PerspectiveFields.git
# Install PyTorch with CUDA (override the CPU versions from core dependencies)
echo "Installing PyTorch with CUDA..."
python -m pip install torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 --index-url https://download.pytorch.org/whl/cu124

# Install additional pip packages
echo "Installing additional pip packages..."
python -m pip install warp-lang
python -m pip install xformers==0.0.28.post3
python -m pip install git+https://github.com/EasternJournalist/utils3d.git@9a4eb15e4021b67b12c460c7057d642626897ec8
python -m pip install xatlas

# Create modules directory if it doesn't exist
echo "Creating modules directory..."
if [ ! -d "modules" ]; then
    echo "Creating modules directory..."
    mkdir modules
fi
cd ./modules/

echo "Setting up b3d..."
clone_if_not_exists "https://github.com/probcomp/b3d.git" "b3d"
cd b3d
git fetch && git checkout xw/pixi-fixes
python -m pip install -e .
cd ../

# Clone and install SAM2
echo "Setting up SAM2..."
clone_if_not_exists "https://github.com/facebookresearch/sam2.git" "sam2"
cd sam2/
python -m pip install -e .
cd ..

# Clone and install Depth-Anything-V2
echo "Setting up Depth-Anything-V2..."
clone_if_not_exists "https://github.com/DepthAnything/Depth-Anything-V2.git" "Depth_Anything_V2"
cd Depth_Anything_V2
install_requirements "requirements.txt"
cd metric_depth
install_requirements "requirements.txt"

# Create checkpoints directory if it doesn't exist
mkdir -p checkpoints

# Download model checkpoints
download_if_not_exists "https://huggingface.co/depth-anything/Depth-Anything-V2-Large/resolve/main/depth_anything_v2_vitl.pth?download=true" "checkpoints/depth_anything_v2_vitl.pth"
download_if_not_exists "https://huggingface.co/depth-anything/Depth-Anything-V2-Metric-Hypersim-Large/resolve/main/depth_anything_v2_metric_hypersim_vitl.pth?download=true" "checkpoints/depth_anything_v2_metric_hypersim_vitl.pth"

cd ../..

echo "Setting up nvdiffrast..."
clone_if_not_exists "https://github.com/NVlabs/nvdiffrast" "nvdiffrast"
cd nvdiffrast
python -m pip install -e .
cd ..

# Set PYTHONPATH
export PYTHONPATH=$PYTHONPATH:$(pwd)/modules/Depth-Anything-V2

# Build extensions (assuming this should be run in nvdiffrast directory)
echo "Building CUDA extensions..."
cd nvdiffrast
if [ -f "setup.py" ]; then
    python setup.py build_ext --inplace
else
    echo "Warning: setup.py not found in nvdiffrast directory"
fi
cd ..

echo "Setting up TRELLIS..."
clone_if_not_exists "https://github.com/microsoft/TRELLIS.git" "trellis"

echo "Setting up dino_vit_features..."
clone_if_not_exists "https://github.com/AryanZoroufi/dino-vit-features.git" "dino_vit_features"

echo "Setting up kaolin..."
clone_if_not_exists "https://github.com/NVIDIAGameWorks/kaolin.git" "kaolin"
cd kaolin
python -m pip install --force-reinstall --no-deps torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 --index-url https://download.pytorch.org/whl/cu124
pip install --no-deps ninja setuptools wheel cython pybind11
export TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;8.9;9.0"
rm -rf build/ kaolin/_C.so kaolin/ops/conversions/mise.so
python setup.py build_ext --inplace
SITE_PACKAGES=$(python -c "import site; print(site.getsitepackages()[0])")
echo "$(pwd)" > "$SITE_PACKAGES/kaolin.pth"
cd ..

echo "Installing additional pip packages..."
pip install --no-deps scipy numpy pillow tqdm ipyevents ipycanvas jupyter flask tornado comm usd-core dataclasses_json marshmallow typing_inspect mypy_extensions pygltflib easydict rembg onnxruntime pymatting pooch diffusers transformers numba llvmlite regex pyvista pymeshfix igraph texttable scooby huggingface_hub rembg safetensors spconv-cu121 pccm ccimport lark cumm sentencepiece
pip install transformers -U
pip install accelerate plotly
pip install "rembg[gpu,cli]" # for library + cli
# pip install git+https://github.com/lucasb-eyer/pydensecrf.git

# echo "Setting up SceneComplete..."
# clone_if_not_exists "https://github.com/SceneComplete/SceneComplete.git" "SceneComplete"
# cd SceneComplete
# git submodule update --init --recursive
# cd scenecomplete/modules/BrushNet
# pip install -e .
# pip install huggingface_hub==0.23.2 peft==0.12.0
# cd ../../..
# pip install -e .
# cd scenecomplete/modules/weights
# bash download_weights.sh
# cd ../../../../..

export LD_LIBRARY_PATH=$PWD/.pixi/envs/default/lib:$LD_LIBRARY_PATH

echo "Setup complete! All repositories and dependencies have been installed."
echo "PYTHONPATH has been set to include Depth-Anything-V2"