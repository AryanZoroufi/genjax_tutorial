## 📦 Installation

### Prerequisites
- **System**: The code is currently tested only on **Linux**.
- **Hardware**: An NVIDIA GPU is necessary to execute the code. Some foundation models (e.g. Trellis) require at least 24gb VRAM. The code has been verified on NVIDIA H100 GPUs. 
- **Software**:   
  - The [CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit-archive) is needed to compile certain submodules. The code has been tested with CUDA version 12.9.  
  - Python version 3.10 or higher is required. The code has been tested with Python 3.12.

### Installation Steps

0. **Install Pixi** (see [Pixi's installation guide](https://pixi.sh/latest/installation/) for details):
    ```sh
    curl -fsSL https://pixi.sh/install.sh | sh
    ```

1. **Clone the repository**:
    ```sh
    git clone https://github.com/AryanZoroufi/genjax_tutorial.git
    cd genjax_tutorial
    ```
2. Make setup file executable
    ```sh
    chmod +x setup.sh
    chmod +x setup_simple.sh
    ```

3. **Install dependencies** (this may take a few minutes):
    
**Full installation** (advanced features):
- Includes: Trellis (shape completion), SAM-2 (segmentation), Depth-Anything-2 (depth estimation), FLUX (image inpainting)
- Note: Takes longer and may encounter errors. Only install if you need these features.

```sh
    pixi run setup
```

**Simple installation** (recommended for most users):
- Includes: inverse graphics, intuitive physics, forward simulation
- Use when depth maps, segmentation masks, and meshes are provided or not needed

```sh
    pixi run setup_simple
```


4. **Connect to Hugging Face** *(optional - only if using Hugging Face models)*:
```sh
    huggingface-cli login
```
    Follow the prompts in the terminal to complete authentication.

5. **Request FLUX access** *(optional - only if using FLUX for image inpainting)*:
   - Visit the [FLUX.1-Fill-dev repository](https://huggingface.co/black-forest-labs/FLUX.1-Fill-dev)
   - Log in to your Hugging Face account
   - Click "Agree" to request repository access

## 💡 Usage

1. **Activate the GPU environment**:
    ```sh
    pixi shell -e gpu
    ```

2. **Run Python scripts** within the environment

3. **For Jupyter Notebook**, run the following command inside a terminal with the GPU environment activated:
    ```sh
    jupyter notebook
    ```
    Use the provided link to access the notebook. **Note**: You will encounter errors if you select the pixi environment directly as the Python interpreter in your Jupyter notebook interface.