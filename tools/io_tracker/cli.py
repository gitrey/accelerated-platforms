import argparse
import json
import sys
from storage import save_announcement, get_announcements, list_categories, init_db

def main():
    parser = argparse.ArgumentParser(description="Google I/O Tracker Storage CLI")
    subparsers = parser.add_subparsers(dest="command", help="Command to execute")

    # init
    subparsers.add_parser("init", help="Initialize the database")

    # save
    save_parser = subparsers.add_parser("save", help="Save an announcement")
    save_parser.add_argument("--title", required=True)
    save_parser.add_argument("--date", required=True, help="YYYY-MM-DD")
    save_parser.add_argument("--category", required=True)
    save_parser.add_argument("--summary", required=True)
    save_parser.add_argument("--url", required=True)

    # list
    list_parser = subparsers.add_parser("list", help="List announcements")
    list_parser.add_argument("--category")
    list_parser.add_argument("--date")
    list_parser.add_argument("--search", dest="search_query")

    # categories
    subparsers.add_parser("categories", help="List all categories")

    args = parser.parse_args()

    if args.command == "init":
        init_db()
        print("Database initialized.")
    elif args.command == "save":
        success = save_announcement(args.title, args.date, args.category, args.summary, args.url)
        if success:
            print("Announcement saved successfully.")
        else:
            print("Failed to save announcement (it might already exist).")
            sys.exit(1)
    elif args.command == "list":
        announcements = get_announcements(args.category, args.date, args.search_query)
        print(json.dumps(announcements, indent=2))
    elif args.command == "categories":
        categories = list_categories()
        print(json.dumps(categories, indent=2))
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
