# Australian Rainfall and Runoff Document Source

This repository contains the complete source code required to build the current edition of Australian Rainfall and Runoff.  The supported formats you can build from here include:

* EPUB
* HTML

If you don't want to build the document yourself from source it can be downloaded for free from the [ARR Website](http://www.arr.org.au).

## Getting Started
### Introduction

The source for ARR is in XML documents using the DocBook V5 schema.  EXtensible Stylesheet Language (XSL) stylesheets are used to Transform (XSLT) the source XML into the desired output.  The majority of this process is transparent to the end user as it is quite rare to touch the sylesheets, with most of the work undertaken in the source XML themselves.

### Prerequisites

TODO: add the pre-requisite instructions.

### Build From Source

The general build process is:

```bash
cd arr
chmod +x build_make_includes
./build_make_includes
make clean
make epub
```

## Contributing

TODO: need to define the contribution process.

## Authors

Too many people have contributed directly to this project to list in this README.  Please see the individual books and chapters as well as the [ARR website](http://www.arr.org.au/) for direct authors and project teams.

## License

The Australian Rainfall and Runoff: A guide to flood estimation (ARR) is licensed under the Creative Commons Attribution 4.0 Licence, unless otherwise indicated or marked.

Please give attribution to: © Commonwealth of Australia (Geoscience Australia) 2015.

### Third Party Material

The Commonwealth of Australia and the ARR’s contributing authors (through Engineers Australia) have taken steps to both identify third-party material and secure permission for its reproduction and reuse. However, please note that where these materials are not licensed under a Creative Commons licence or similar terms of use, you should obtain permission from the relevant third-party to reuse their material beyond the ways you are legally permitted to use them under the fair dealing provisions of the [Copyright Act 1968](http://www.comlaw.gov.au/Details/C2014C00291).

### Further License Questions

If you have any questions about the copyright of the ARR, please contact:

arr\_admin@arr.org.au
c/o 11 National Circuit,
Barton, ACT

ISBN Pending Publication March 2016

How to reference this book:
Ball, J (Ed), Australian Rainfall and Runoff: A Guide to Flood Estimation – Draft for Industry Comment 151205, © Commonwealth of Australia (Geoscience Australia), 2015.

## Acknowledgments
