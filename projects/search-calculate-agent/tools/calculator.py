import sys
import json
import math

def calculate(expression):
    print(f"DEBUG: Calculating '{expression}'", file=sys.stderr)
    try:
        # Use a restricted eval for safety in a PoC
        # In production, use a proper expression parser
        allowed_names = {
            k: v for k, v in math.__dict__.items() if not k.startswith("__")
        }
        result = eval(expression, {"__builtins__": {}}, allowed_names)
        return str(result)
    except Exception as e:
        return f"Error: {str(e)}"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No expression provided"}))
        sys.exit(1)
    
    expression = sys.argv[1]
    result = calculate(expression)
    print(json.dumps({"result": result}))
