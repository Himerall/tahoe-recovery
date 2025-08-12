#!/bin/bash

echo "Monitoring workflow execution..."
echo "Press Ctrl+C to stop monitoring"
echo ""

RUN_ID="16907356204"

while true; do
    STATUS=$(gh run view $RUN_ID --json status | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
    CONCLUSION=$(gh run view $RUN_ID --json conclusion | grep -o '"conclusion":"[^"]*"' | cut -d'"' -f4 2>/dev/null || echo "null")
    
    echo "$(date): Status = $STATUS, Conclusion = $CONCLUSION"
    
    if [ "$STATUS" = "completed" ]; then
        echo ""
        echo "Workflow completed!"
        if [ "$CONCLUSION" = "success" ]; then
            echo "✅ Success! The recovery image has been generated."
            echo "You can download the artifact using:"
            echo "gh run download $RUN_ID"
        elif [ "$CONCLUSION" = "failure" ]; then
            echo "❌ Failed! Check the logs:"
            echo "gh run view $RUN_ID --log"
        fi
        break
    fi
    
    sleep 30
done
