set -e

# -------------------------- Base -------------------------
python -m pip install -U pip setuptools wheel ninja cmake

# PyTorch (cu121)
python -m pip install torch==2.5.1 torchvision==0.20.1 --index-url https://download.pytorch.org/whl/cu121

# -------------------------- For RAM+GPT -------------------------
python -m pip install "git+https://github.com/xinyu1205/recognize-anything.git"
python -m pip install python-dotenv   # <- FIX: dotenv -> python-dotenv
python -m pip install transformers timm fairscale openai

# -------------------------- For DEVA -------------------------
cd submodules/Tracking-Anything-with-DEVA
python -m pip install -e .
cd ../..

# -------------------------- For Grounded-SAM-2 -------------------------
cd submodules/Grounded-SAM-2
python -m pip install -e . -v
# GroundingDINO doesn't exist locally in this repo, install from Git
python -m pip install --no-build-isolation "git+https://github.com/IDEA-Research/GroundingDINO.git" -v
cd ../..

# -------------------------- For Unidepth -------------------------
cd submodules/UniDepth

# install UniDepth without deps (as you wanted)
python -m pip install . --no-deps

# BUT: install the required deps explicitly to avoid runtime surprises
python -m pip install einops wandb xformers==0.0.29 \
  imageio tabulate termcolor trimesh tables torchaudio

# patch nystrom for pytorch 2.5.1
wget -q https://raw.githubusercontent.com/AbdBarho/xformers-wheels/refs/heads/main/xformers/components/attention/nystrom.py \
  -O ./unidepth/layers/nystrom.py
sed -i 's/from xformers\.components\.attention import NystromAttention/from .nystrom import NystromAttention/g' \
  unidepth/layers/nystrom_attention.py

cd ../..

# -------------------------- For TrackingWorld -------------------------
python -m pip install imageio configargparse

# IMPORTANT: pytorch3d needs torch during build; disable build isolation
python -m pip install --no-build-isolation "git+https://github.com/facebookresearch/pytorch3d.git" -v

# -------------------------- For Evaluation -------------------------
python -m pip install evo

# -------------------------- For Visualization-------------------------
python -m pip install rerun-sdk viser

# fix error
python -m pip install -U "transformers==4.30.2" "tokenizers<0.14" -v
