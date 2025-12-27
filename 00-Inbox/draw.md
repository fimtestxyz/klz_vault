---
tags:
  - think-Okay
  - >-
    let-s-tackle-this-task-step-by-step-The-user-wants-me-to-analyze-a-document-about-Computer-Vision
  - >-
    specifically-focusing-on-the-relationship-between-data-scale-and-deep-learning-performance-The-key-topics-here-are-definitely-around-large-scale-datasets-like-JFT-300M
  - performance-metrics-on-benchmarks-such-as-COCO-object-detection
  - and-the-core-concepts-of-deep-learning-in-computer-vision-First
---

# Computer Vision Background and Issues

## Recent Decade of Deep Learning in Computer Vision

- **Significant Development (2012 onwards)**: 
  - Systematic improvement due to deep models, increased computational power, and large-scale labeled data.
  
- **Contradiction**: 
  - Continuous growth in model complexity and computation power. 
  - However, the scale of datasets has not expanded proportionally (ImageNet still contains around 10 million images).
  
- **Core Question**:
  - What is the impact of increasing dataset sizes on model performance? Does it double or stabilize?

## Related Research Introduction

### Key Paper: "Revisiting Unreasonable Effectiveness of Data in Deep Learning Era"

- **Objective**: 
  - Explore the relationship between data and deep learning.
  
- **Key Dataset**:
  - JFT-300M (Google internal dataset with 3 billion images, 18291 categories, over 10 billion labels. After algorithmic filtering to improve precision, it still has about 20% label noise; recall rate is not estimable).

## Experimental Findings

### Key Discoveries:
- **Data Enrichment for Representation Learning**: 
  - Large datasets significantly enhance the performance of various visual tasks.
  
- **Performance and Data Scale Relationship**:
  - Performance increases logarithmically with the amount of training data used in representation learning (e.g., JFT-300M subsets' performance on COCO object detection benchmark).
  
- **Model Capacity Matters**: 
  - Deeper models are better at utilizing a large dataset, as seen by ResNet-152's improvement over ResNet-50 in the COCO detection benchmark.
  
- **Benchmark Breakthroughs**:
  - New best results on multiple benchmarks (e.g., single model AP reaches 37.4% in COCO detection benchmark, surpassing previous 34.3%).

## Limitations and Future Directions

### Limitations: 
- Training mechanisms, learning schedules, and hyperparameters are based on ImageNet experience.
- The reported performance may be underestimated due to the lack of optimal parameter search.
  
- **Future Focus**:
  - Collect large-scale task-specific data; explore model performance with even larger datasets (10 billion+ images).

## Acknowledgements

### Key Contributors: 
- Chen Sun, Abhinav Shrivastava, Saurabh Singh, Abhinav Gupta
  
### Thanks to:
- Google Image Understanding and Expansion Team for building the JFT dataset.
- Tom Duerig et al. (for API support).