package kubernetes.admission                                               

deny[msg] {                                                                
  input.request.kind.kind == "Pod"                                         
  image := input.request.object.spec.containers[_].image                 
  not contains(image, "pivotal.io")                  
  msg := sprintf("Image :: %v comes from Non pivotal registry", [image])
}