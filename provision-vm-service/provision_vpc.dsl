{
  "Comment": "Basic Provisioning demo",
  "StartAt": "PreProvision",
  "States": {
    "PreProvision": {
      "Type": "Pass",
      "Next": "Provision"
    },
    "GenerateSuffix": {
      "Type": "Pass",
      "Parameters": {
        "suffix.$": "States.MathRandom(1,1000)",
        // build an override object here
        "override": {
          "vm_name,e.$": "States.Format('demo-techzone-vm-{}', $.suffix)",
          "service_name.$": "States.Format('demo-techzone-sn-{}',  $.suffix)"
        }
      },
      "ResultPath": "$",     /* stash $.suffix & $.override at top level */
      "Next": "Provision"
    },
    "Provision": {
      "Type": "Task",
      "Resource": "manageiq://provision_execute",
      "Parameters": {
        // merge your original vm_fields with just the two override keys
        "vm_fields.$": "States.JsonMerge($.vm_fields, $.override, false)"
      },
      "Next": "PostProvision"
    },
    "PostProvision": {
      "Type": "Pass",
      "End": true
    }
  }
}

