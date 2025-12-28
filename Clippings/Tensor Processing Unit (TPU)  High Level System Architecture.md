---
title: "Tensor Processing Unit (TPU):  High Level System Architecture"
source: "https://qsysarch.com/posts/tpu-architecture/text=At%20a%20high%20level%2C%20yes,self%2Ddriven%E2%80%9D%20systolic%20array."
author:
  - "[[Quantum Computer System Architecture]]"
published: 2025-12-12
created: 2025-12-28
description: "Why do we need TPUs if we already have GPUs? A deep dive into the world of the Tensor Processing Units."
tags:
  - "clippings"
---
![](https://qsysarch.com/images/tensor-processors/tpu-vs-gpu.webp)

==In a world where AI is energy-hungry, the ==Tensor Processing Unit== (TPU) is a game-changer. It is a custom-built chip designed by Google specifically for machine learning tasks.==

==This quick memo is an attempt to provide a high-level system view of the TPUs’ architecture and how they have evolved since their inception in 2016.==

==I will also try to answer this essential question: why do we need TPUs if we already have GPUs? What kind of advantages do they have that the GPU does not? How do they compare to the Neuromorphic ICs? And is there any alternative architecture to the TPUs and GPUs?==

![Tensor Processing Unit evolution over time](https://qsysarch.com/images/tensor-processors/tpu-evolution.webp) (Source: [Google Cloud](https://cloud.google.com/transform/ai-specialized-chips-tpu-history-gen-ai))

## Why the TPU exists — and what problems it solves

The TPU share the same goal as the GPU: to overcome the limitation introduced from the slowing of Moore’s Law, by enabling massive parallelism: Unlike traditional CPU which can be used to handle generic computations, and which, to some extend, has a level of parallelism via the concept of multi-core (thanks to [Dennard scaling’s law](https://qsysarch.com/posts/tpu-architecture/youtube.com/watch?si=C2JVSw49rUYMWXcE&v=7p8ZeSbblec&feature=youtu.be&themeRefresh=1)), the TPU and GPU are specialized hardware designed to handle simple and specific tasks, but in a much more efficenct way that any CPU could.

At a high level, one can say that deliver much better performance and efficiency than general-purpose CPUs or GPUs by “ *trading off generality for performance*.” ![Google Systolic Array](https://qsysarch.com/images/tensor-processors/systolic-array.webp#right)

==The TPU is fundamentally designed for heavy linear algebra tasks, such as matrix multiplications and tensor operations, that neural networks use.==

At the heart of the TPU is the systolic array, a matrix of processing elements (usually called *PE*, denoted as *MAC* on the diagram on the right) that can perform parallel computations.

==In the case of the TPU, this processing unit, or MAC, is a simple 8-bit multiplier that multiplies and accumulates the activation values (the embedding) with the neural network’s weights. Only by performing this operation in a massively parallel way does the TPU achieve a much higher throughput than a CPU. And so do the GPUS! But first, let’s take a look at the evolution of TPU over time.==

## TPU evolution over time

## TPUv1: the first generation of TPU

==The TPUv1 was developed in just 15 months, with the principal goal of improving neural network inference (not even learning, but only inference). For this, Google needed matrix multipliers and had constraints not only on achieving high speed but also on reducing power consumption. The key to reducing power consumption was improving memory locality, e.g., reducing unnecessary data movement between external memory and TPU memory. This would allow increasing the arithmetic intensity per unit of control, i.e., reducing the TPU’s idle time waiting for data.==

==From the HW perspective, the TPU v1 design was straightforward yet elegantly effective:==

- ==single threaded co-processor on a standard PCie card.==
- ==No multi level cache, no multhreading, no branch prediction.==
- ==Fast determinstic math on 8bits integers via the MXU, or matrix multiplication unit.==
- ==Systolic array constist of 256 \* 256 \* MXU==

==The complexity was moved to the software scheduler, with two main responsibilities:==

- ==keep the pipe busy, by schedule the operations in a way that the MXU was never idle.==
- ==double buffer the memory, as a mean to hide the latency of the memory access==

![Google Tensor Processing Unit TPU evolution, from V1 to V3](https://qsysarch.com/images/tensor-processors/tpu-v1-v2-v3.webp)

## TPUv2 and v3: Improving memory and interconnect

==The key concepts in v2 and v3 are training the next generation of models that require backpropagation, higher precision, and many more distributed, interconnected TPUs.==

====From the HW Core Processing perspective, they introduced quite a few nice concepts:====

- a dual core chip, eg one **TPUv2** is made of two TPU
- Each TPU had a four time larger systolic array, consistsi of **128\*128 MXU**,
- Ability to handle floating point values, using the Brain Floating Point Format (**BF16**), an enhanced version of the standard IEEE 754 FP16 floating point format.
- A new high bandwidth memory (**HBM**) within the TPU to memory access latency; (TPUv1 only has a basic DRAM, with slow access time, while the HBM is much faster)

![Brain Floating Point Format](https://qsysarch.com/images/tensor-processors/bf16.webp)

====From the HW Connectivity perspective,====

- An Inter-core interconnect (**ICI**), the high bandwidth fabric that allows scale, via a 16x16 2D torus network (ring network) - Super computer pod of 256 chips.

![Block diagram of a TensorCore TPUv2](https://qsysarch.com/images/tensor-processors/tpuv2.webp)

==From the SW perspective, a powerful compiler:==

- [XLA compiler](https://en.wikipedia.org/wiki/Accelerated_Linear_Algebra): the brain generating the VLIW instructions used by the core sequencer (**TCS**).

## TPUv4: Hyper scale AI

The key concept in v4 was the ability to run AI models at hyper-scale. This meant that the key driving metric was the Total Cost of Ownership (**TCO**).

==The newest generations are designed for large-scale training. Chips are connected in racks or pods, with advanced memory systems and interconnects. They support large tensor operations, distributed training, synchronisation, and efficient data sharing across many chips.==

From the HW Core Processing perspective, they introduced quite a few nice concepts:

- ==Spares core: prevent “zero-ops” from hitting the MXU -> improve memory utilisation.==
- ==Memory Cache: (20x more efficient than access remote RAM)==

![TPUv4 Chip Architecture](https://qsysarch.com/images/tensor-processors/tpuv4-chip-architecture.webp)

From the HW Connectivity perspective,

- ==The TPUv4 just like the TPUv2 and v3 are still using an Interconnect router (ICI), implemented as an high-speed electrical link between the TPUs within the same rack.==
- ==However, the TPUv4 gets an additional Optial link between the racks, called Optical Circuit Switching, or OCS. This allows increasing the number of TPUs in a pod to 4K (compared to 64 in a single rack), as well as mitigating failures by reconfiguring OCS routing.==
- ==Last, but the least, the routing now becomes 3 dimensionnal, by implemented a 3d torus, which has the non negligible advantange to scale the communication efficiency much better than the 2d torus.==

![TPUv4 Block Connectivity](https://qsysarch.com/images/tensor-processors/tpuv4.webp)

==From the SW perspective:==

- Introduction of new tools: [Borg](https://research.google/pubs/borg-the-next-generation/) as the cluster manager; pod manager to configure the OCS; and Libpunet to setup the ICI routing tables and cope with fault tolerance.
- Advanced single program multiple data ([SPMD](https://arxiv.org/pdf/2401.11202v4)) compiler: This can be seen as a compiler generating multiple threads, where each thread is a program runing on a different TPU within the same rack or not. It is somewhat similar to the SIMT concept of the GPU, where the compiler generates code for the threads within a GPU warp.
- Since many TPUs are running the same program, the Borg orchestrator needs to make sure that all of the TPUs are cosynchrnous - that’s the role of the [Gang Scheduler](https://en.wikipedia.org/wiki/Gang_scheduling).

![TPUv4 Rack, Super Pod and OCS](https://qsysarch.com/images/tensor-processors/tpuv4-scale.webp)

- ==Explain the concept of “pathways”, needed to handle asynchronous dataflow for MoE.==

### The SparseCore

The [SparseCore](https://openxla.org/xla/sparsecore) (aka *SC*) in TPUv4 is responsible for accelerating workloads with sparse matrix, where most of the values are zeros or redundant (which is the case for the embeddeings found in LLMs). It is described as an “embedding lookup” optimizer, and each TPUv4 includes four 4 SparseCore processors.

![Gogole TPUv4 SpareCore Architecture](https://qsysarch.com/images/tensor-processors/tpuv4-sparecore-architecture.webp) (image adapted from the original [image source](https://arxiv.org/pdf/2304.01433))

==The SparseCore Sequencer (in red on the top left corner) is the orchestrator responsible for disptaching instructions to the 5 cross channel units (in orange), as well as to the 3 “fetch/process/flush” SIMD units (in blue). Each SIMD units operate on their own 2.5MB tighly coupled memory scratchpad (in grey).==

==Given that each fetch/process/flush SIMD unit operates 8 data lanes at a time (SIMD=8), and that there are 16 of those SIMD units in a Sparse Core processor, that makes it a very powerfull processing unit, almost like a tiny GPU inside the GPU! Or to be precise, 4 tiny GPUs inside a TPU!==

<svg xmlns="http://www.w3.org/2000/svg" style="float:right;height:100px;margin-left:20px" viewBox="0 0 451 260.81"><defs></defs><title>JAX Light Stroke</title><g id="Layer_2" data-name="Layer 2"><g id="Layer_1-2" data-name="Layer 1"><polygon class="cls-1" points="50.5 130.4 25.5 173.71 75.5 173.71 100.5 130.4 50.5 130.4"></polygon><polygon class="cls-1" points="0.5 217.01 25.5 173.71 75.5 173.71 50.5 217.01 0.5 217.01"></polygon><polygon class="cls-1" points="125.5 173.71 75.5 173.71 50.5 217.01 100.5 217.01 125.5 173.71"></polygon><polygon class="cls-1" points="175.5 173.71 125.5 173.71 100.5 217.01 150.5 217.01 175.5 173.71"></polygon><polygon class="cls-1" points="150.5 130.4 125.5 173.71 175.5 173.71 200.5 130.4 150.5 130.4"></polygon><polygon class="cls-1" points="175.5 87.1 150.5 130.4 200.5 130.4 225.5 87.1 175.5 87.1"></polygon><polygon class="cls-1" points="200.5 43.8 175.5 87.1 225.5 87.1 250.5 43.8 200.5 43.8"></polygon><polygon class="cls-1" points="225.5 0.5 200.5 43.8 250.5 43.8 275.5 0.5 225.5 0.5"></polygon><polygon class="cls-2" points="0.5 217.01 25.5 260.31 75.5 260.31 50.5 217.01 0.5 217.01"></polygon><polygon class="cls-2" points="125.5 260.31 75.5 260.31 50.5 217.01 100.5 217.01 125.5 260.31"></polygon><polygon class="cls-2" points="175.5 260.31 125.5 260.31 100.5 217.01 150.5 217.01 175.5 260.31"></polygon><polygon class="cls-3" points="200.5 217.01 175.5 173.71 150.5 217.01 175.5 260.31 200.5 217.01"></polygon><polygon class="cls-3" points="250.5 130.4 225.5 87.1 200.5 130.4 250.5 130.4"></polygon><polygon class="cls-3" points="250.5 43.8 225.5 87.1 250.5 130.4 275.5 87.1 250.5 43.8"></polygon><polygon class="cls-4" points="125.5 173.71 100.5 130.4 75.5 173.71 125.5 173.71"></polygon><polygon class="cls-5" points="250.5 130.4 200.5 130.4 175.5 173.71 225.5 173.71 250.5 130.4"></polygon><polygon class="cls-5" points="300.5 130.4 250.5 130.4 225.5 173.71 275.5 173.71 300.5 130.4"></polygon><polygon class="cls-6" points="350.5 43.8 325.5 0.5 300.5 43.8 325.5 87.1 350.5 43.8"></polygon><polygon class="cls-6" points="375.5 87.1 350.5 43.8 325.5 87.1 350.5 130.4 375.5 87.1"></polygon><polygon class="cls-6" points="400.5 130.4 375.5 87.1 350.5 130.4 375.5 173.71 400.5 130.4"></polygon><polygon class="cls-6" points="425.5 173.71 400.5 130.4 375.5 173.71 400.5 217.01 425.5 173.71"></polygon><polygon class="cls-6" points="450.5 217.01 425.5 173.71 400.5 217.01 425.5 260.31 450.5 217.01"></polygon><polygon class="cls-6" points="425.5 0.5 400.5 43.8 425.5 87.1 450.5 43.8 425.5 0.5"></polygon><polygon class="cls-6" points="375.5 87.1 400.5 43.8 425.5 87.1 400.5 130.4 375.5 87.1"></polygon><polygon class="cls-6" points="350.5 130.4 325.5 173.71 350.5 217.01 375.5 173.71 350.5 130.4"></polygon><polygon class="cls-6" points="325.5 260.31 300.5 217.01 325.5 173.71 350.5 217.01 325.5 260.31"></polygon><polygon class="cls-7" points="275.5 260.31 250.5 217.01 300.5 217.01 325.5 260.31 275.5 260.31"></polygon><polygon class="cls-8" points="225.5 173.71 175.5 173.71 200.5 217.01 250.5 217.01 225.5 173.71"></polygon><polygon class="cls-8" points="275.5 173.71 225.5 173.71 250.5 217.01 275.5 173.71"></polygon><polygon class="cls-8" points="275.5 87.1 300.5 130.4 350.5 130.4 325.5 87.1 275.5 87.1"></polygon><polygon class="cls-8" points="300.5 43.8 250.5 43.8 275.5 87.1 325.5 87.1 300.5 43.8"></polygon><polygon class="cls-8" points="425.5 260.31 400.5 217.01 350.5 217.01 375.5 260.31 425.5 260.31"></polygon><polygon class="cls-8" points="375.5 173.71 350.5 217.01 400.5 217.01 375.5 173.71"></polygon><polygon class="cls-9" points="325.5 0.5 275.5 0.5 250.5 43.8 300.5 43.8 325.5 0.5"></polygon><polygon class="cls-9" points="325.5 173.71 275.5 173.71 250.5 217.01 300.5 217.01 325.5 173.71"></polygon><polygon class="cls-9" points="350.5 130.4 300.5 130.4 275.5 173.71 325.5 173.71 350.5 130.4"></polygon><polygon class="cls-9" points="425.5 0.5 375.5 0.5 350.5 43.8 400.5 43.8 425.5 0.5"></polygon><polygon class="cls-9" points="375.5 87.1 350.5 43.8 400.5 43.8 375.5 87.1"></polygon></g></g></svg>

It would be really nice to have a look at the ISA used to program this powerfull SparseCore procesing unit, but I could not find any information online. It’s probably because it is more like a powerfull “ *Synchronous SIMD ALU-capable DMA computer* ” with so specific instructions that it only make sense to provide an higher level abstraction, such as the [JAX](https://github.com/jax-ml/jax-tpu-embedding/tree/main/jax_tpu_embedding/sparsecore) library.

==In practice, the user writes the high-level functional code, and the XLA (Accelerated Linear Algebra) compiler identifies patterns that match the SparseCore’s hardware capabilities.==

```python
import jax

import jax.numpy as jnp

from flax import linen as nn

# 1. Define the Embedding Table

# Imagine 1 million items, each represented by a 128-dimension vector

vocab_size = 1_000_000

embed_dim = 128

class SparseModel(nn.Module):

    @nn.compact

    def __call__(self, indices):

        embedding_layer = nn.Embed(num_embeddings=vocab_size, features=embed_dim)

        return embedding_layer(indices)

# 2. Input data (Indices)

# Note that index 105 and 42 are represented twice - GH the XLA compiler

# be able to tell the SC to only fetch 3 memory location, and not just 5?

input_indices = jnp.array([105, 42, 28, 42, 105]) 

# 3. Generate the actual TPU/SC code (well, that's called compilation!)

model = SparseModel()

params = model.init(jax.random.PRNGKey(0), input_indices)

output = model.apply(params, input_indices)
```

What happens under the hood? The method `model.apply` calls the XLA compiler, which lowers the code to the SparseCore. For this, it matches the `nn.Embed` (a *gather* operation), and generates the following “pseudo-instructions”:

- *Dedup*: XLA notices 42 and 105 appear twice in your input. It generates SparseCore instructions to deduplicate these before the fetch.
- *DMA*: Generates the SC-scalar instructions to calculate the memory offsets for IDs 105, 42, and 28.
- *Push*: Moves back the resulting 5\*128 tensor into the Common Memory (CMEM).

The XLA compiler also need to take care of data placement. In particular, since the Sparse Core will need to access the `nn.Embed` indices, those indices need to be placed in a memory accessible by the sparse core. It could put it in the CMEM, but it is quite small (128MB), so it usually puts the embeddeing in the large HBM (32GB for TPUv4). The output of the Sparse Core processing is however put back in the CMEM, has it is only a slice of the data.

==It is also worth noticing that the SparseCore architecture has evolved in the next v6+ generations.==

### MoE Mixture-of-Experts and Pathways

==The Mixture-of-Experts (MoE), unlike conventional …==

The **pathways** concept refer to the physical and logical routes tokens take as they are sharded across experts living on different TPU chips.

![Gogole TPUv4 SpareCore Architecture](https://qsysarch.com/images/tensor-processors/tpu-moe-pathways.webp) ([image source](https://arxiv.org/pdf/2203.12533))

## 2023 onward: v5, v6 (Trillum) and v7 (Ironwood)

==There is not much information available on the newer generations, so those are the big headlights:==

- ==v5e: 16 GiB HBM3e per chip;==
- ==v5p: 95 GiB HBM3e per chip;==
- ==v6: 32 GiB HBM3e per chip; Improved BF16 performance==
- v7: 192 GiB HBM3e; New FP8 precision

==With Ironwood v7, a super pod consists of ~9K TPUs.==

![](https://qsysarch.com/images/tensor-processors/ironwood-hero.webp)

## So, why do we still need GPUs if we have TPUs

====The TPU’s design, which balances memory, computing power, energy use, and data communication, shows that building high-performance AI systems at scale is not just about having fast chips. It also requires coordination between hardware, software, systems, and network connections.====

## Processing pixels vs processing matrices

==Even though AI workloads are more varied nowadays, covering inference, training, sparse models, and recommendation systems, TPUs are not designed to process pixels. GPUs, however, are not popular today because Nvidia exposed a programmatic model and developer experience that enabled GPUs to behave like a TPU.==![](https://qsysarch.com/images/tensor-processors/gpu-pixel-shader.webp#right)

==Does this mean that GPUs are superior? Not necessarily - given very specific workloads, TPUs can be more efficient than GPUs, especially in terms of power consumption and performance per watt. And in the world we live in, where AI data centers consume ever more energy, TPU may make all the difference.==

## What about analog neuromorphic ICs?

And what about [neuromorphic ICs](https://qsysarch.com/posts/neuromorphic-ics-system-architecture/)? Compared to TPU, they aim for even lower power consumption by using analog computing and lower-frequency event-driven processing. What will it take for neuromorphic ICs to become mainstream and reach the same scale as the TPUv7 super pods?![](https://qsysarch.com/images/neuromorphic-ics/neuron-circuit.webp#right)

==One of the challenges I still have is to better understand the relative power consumption of the systolic array (MXU + Spares Core) vs the rest of the TPU (including ICI, OCI, TCS), and how this ratio compares to the neuromorphic Spiking Neural Network (SNN) vs control logic (RiscV and Spike copro).==

==Also, if the Neuromorphic ICs were to reach the scale of TPUv7, it would likely require a similar level of investment in software, systems, and network connections. If not, one could consider plugging an SNN into a TPU and using the TPU’s “control logic” to handle communication between the SNN and the rest of the TPU/Rack/Pad. But is there a need for this? What problem are we solving? Maybe one needs to think differently.==

## Back to the future: the Language Processing Unit

This memo would not be complete without mentioning the [Language Processing Unit](https://arxiv.org/pdf/2408.07326v1), a new type of processor designed to optimize the inference of large language models.

I will need to create a dedicated memo for this single topic, so for now, this is just a high-level comparison, trying to understand whether the [LPU](https://www.youtube.com/watch?v=gpe9kFhyu70) is more than a reinvention of the TPUv1, which was only focused on inference and not training.![HyperAccel latency processing unit (LPU)](https://qsysarch.com/images/tensor-processors/lpu.webp)

At a high level, yes, TPU and LPU share the need to do a few things very efficiently, and at scale, using a Domain-Specific architecture ([DSAs](https://en.wikipedia.org/wiki/Domain-specific_architecture)). But when it comes to specific implementation and optimization, the LPU is a very different beast, with a different focus.![](https://qsysarch.com/images/tensor-processors/groq-lpu.webp#right)

==The main difference is that the TPUv1 was designed before the LLM even existed (remember, ChatGPT’s initial release was in 2022), and was focused on general Deep Neural Network (DNN) inference. That meant ensuring throughput and performance per watt for massive, high-volume operations, implemented by an underlying MXU systolic array.==

==The LPU, on the other hand, is designed to optimize the inference of large language models (LLMs). Their focus is on improving the latency per token. And for that, they need an ISA that supports a fully deterministic, statically scheduled, VLIW-based multi-pipeline architecture. Of course, one may argue that the TPUv4 introduces a similar VLIW ISA for the TCS. But the main difference is that the LPU ISA is a fully deterministic VLIW machine, where every load, compute, and store is scheduled cycle by cycle. While for the TPU, the MXU is a “self-driven” systolic array.==

## Conclusion

==Voilà, this is a short memo that, once again, took longer than expected. What is clear from this deep dive is that the evolution of the TPU architecture shows that designing AI accelerators is a complex task that requires balancing many factors.==

The TPU’s design, which balances memory, computing power, energy use, and data communication, shows that building high-performance AI systems at scale is not just about having fast chips. It also requires coordination between hardware, software, systems, and network connections.

==This is a bit of a feeling of déjà vu. Could it be that the Quantum Processing Unit (QPU) is the next step in the evolution of AI accelerators?==

![Google Willow roadmap](https://qsysarch.com/images/tensor-processors/willow-roadmap.webp) (image source: [Google Willow](https://blog.google/technology/research/google-willow-quantum-chip/))

---

## References

- [==An in-depth look at Google’s first Tensor Processing Unit (TPU)==](https://cloud.google.com/blog/products/ai-machine-learning/an-in-depth-look-at-googles-first-tensor-processing-unit-tpu)
- [==Touching the Elephant - TPUs: Understanding the Tensor Processing Unit==](https://considerthebulldog.com/tte-tpu/)
- [==TPU Architecture: Complete Guide to Google’s 7 Generations==](https://introl.com/blog/google-tpu-architecture-complete-guide-7-generations)
- [Tensor Processing Unit](https://en.wikipedia.org/wiki/Tensor_Processing_Unit)
- [==Why Google’s TPU Could Beat NVIDIA’s GPU in the Long Run==](https://philippeoger.com/pages/why-googles-tpu-could-beat-nvidias-gpu-in-the-long-run)
- [==LPU: A Latency-Optimized and Highly Scalable Processor for Large Language Model Inference==](https://arxiv.org/pdf/2408.07326v1)
- [==TPUv2: A DomainSpecific Supercomputer for Training Deep Neural Networks==](https://dl.acm.org/doi/pdf/10.1145/3360307)
- [==TPU v4: An Optically Reconfigurable Supercomputer for Machine Learning with Hardware Support for Embeddings==](https://arxiv.org/pdf/2304.01433)
- [==A Machine Learning Supercomputer With An Optically Reconfigurable Interconnect and Embeddings Support==](https://hc2023.hotchips.org/assets/program/conference/day2/ML%20training/HC2023.Session5.ML_Training.Google.Norm_Jouppi.Andy_Swing.Final_2023-08-25.pdf)
- [==Resiliency at Scale: Managing Google’s TPUv4 Machine Learning Supercomputer==](https://www.usenix.org/system/files/nsdi24-zu.pdf)
- [==TPU deep dive==](https://henryhmko.github.io/posts/tpu/tpu.html)
- [==Ten Lessons From Three Generations Shaped Google’s TPUv4i==](https://gwern.net/doc/ai/scaling/hardware/2021-jouppi.pdf)
- [==How to Think About TPUs==](https://jax-ml.github.io/scaling-book/tpus/)
- [==Google’s AI Processor’s (TPU) Heart Throbbing Inspiration==](https://medium.com/intuitionmachine/googles-ai-processor-is-inspired-by-the-heart-d0f01b72defe)
- [==Tensor Processor Unit (TPU)==](https://courses.grainger.illinois.edu/cs433/fa2022/projects/Google-TPU.pdf)
- [==Raytracing & GLSL==](https://www.cs.princeton.edu/courses/archive/spring19/cos426/precepts/07-glsl.pdf)

==DrawIO diagrams used in this memo:==

![](https://qsysarch.com/images/tensor-processors/tpu-v1-v2-v3.webp)  
[.drawio](https://qsysarch.com/images/tensor-processors/tpu-v1-v2-v3.drawio)[.webp](https://qsysarch.com/images/tensor-processors/tpu-v1-v2-v3.webp)[.svg](https://qsysarch.com/images/tensor-processors/tpu-v1-v2-v3.svg)  
tpu v1 v2 v3