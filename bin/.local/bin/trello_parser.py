#!/usr/bin/env python3
"""
Trello JSON Export Parser
Converts Trello board exports to structured markdown for project tracking
"""

import json
import sys
from datetime import datetime
from pathlib import Path

def parse_trello_export(json_file_path, output_file_path=None):
    """Parse Trello JSON export and generate markdown summary"""
    
    # Load JSON data
    with open(json_file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Extract basic board info
    board_name = data.get('name', 'Unknown Board')
    board_url = data.get('shortUrl', '')
    last_activity = data.get('dateLastActivity', '')
    
    # Format date
    if last_activity:
        try:
            date_obj = datetime.fromisoformat(last_activity.replace('Z', '+00:00'))
            formatted_date = date_obj.strftime('%Y-%m-%d')
        except:
            formatted_date = last_activity[:10]
    else:
        formatted_date = 'Unknown'
    
    # Extract labels and their meanings
    labels = data.get('labelNames', {})
    label_meanings = {k: v for k, v in labels.items() if v}
    
    # Extract lists
    lists = {lst['id']: lst for lst in data.get('lists', [])}
    
    # Extract cards
    cards = data.get('cards', [])
    
    # Extract members
    members = {member['id']: member for member in data.get('members', [])}
    
    # Organize cards by list
    cards_by_list = {}
    for card in cards:
        list_id = card.get('idList')
        if list_id not in cards_by_list:
            cards_by_list[list_id] = []
        cards_by_list[list_id].append(card)
    
    # Generate markdown content
    md_content = f"""# {board_name} Project Tracker

**Board URL:** {board_url}  
**Last Updated:** {formatted_date}  
**Project Type:** Medical Administration System Development

## Team Members
"""
    
    # Add team members
    for member in members.values():
        initials = member.get('initials', '')
        full_name = member.get('fullName', '')
        md_content += f"- **{full_name}** ({initials})\n"
    
    md_content += "\n## Priority System\n"
    
    # Add priority/label system
    priority_emojis = {
        'red': '🔴',
        'orange': '🟠', 
        'green': '🟢',
        'purple': '🟣',
        'blue': '🔵',
        'sky_light': '🩵'
    }
    
    for color, meaning in label_meanings.items():
        emoji = priority_emojis.get(color, '⚪')
        md_content += f"- {emoji} **{meaning}** ({color})\n"
    
    md_content += "\n## Lists and Tasks\n"
    
    # Add lists and their cards
    for list_id, list_info in lists.items():
        if not list_info.get('closed', False):  # Only show open lists
            list_name = list_info.get('name', 'Unknown List')
            list_cards = cards_by_list.get(list_id, [])
            active_cards = [card for card in list_cards if not card.get('closed', False)]
            
            md_content += f"\n### {list_name} ({len(active_cards)} tasks)\n"
            
            for card in active_cards:
                if card.get('closed', False):
                    continue
                    
                card_name = card.get('name', 'Unnamed Card')
                card_id = card.get('idShort', '')
                due_date = card.get('due', '')
                
                # Format due date
                if due_date:
                    try:
                        due_obj = datetime.fromisoformat(due_date.replace('Z', '+00:00'))
                        formatted_due = due_obj.strftime('%Y-%m-%d')
                    except:
                        formatted_due = due_date[:10]
                    due_text = f" - Due: {formatted_due}"
                else:
                    due_text = ""
                
                # Check if completed
                is_completed = card.get('dueComplete', False)
                status_icon = "✅" if is_completed else "⏳"
                
                md_content += f"{len(active_cards) - active_cards.index(card)}. **{card_name}** (#{card_id}){due_text} {status_icon}\n"
    
    # Add project statistics
    total_cards = len([card for card in cards if not card.get('closed', False)])
    completed_cards = len([card for card in cards if card.get('dueComplete', False) and not card.get('closed', False)])
    
    md_content += f"""
## Project Statistics

- **Total Active Tasks:** {total_cards}
- **Completed Tasks:** {completed_cards}
- **Progress:** {completed_cards/total_cards*100:.1f}%
- **Team Size:** {len(members)}
- **Active Lists:** {len([lst for lst in lists.values() if not lst.get('closed', False)])}

---
*Generated from: {Path(json_file_path).name}*
*Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}*
"""
    
    # Write to file or return content
    if output_file_path:
        with open(output_file_path, 'w', encoding='utf-8') as f:
            f.write(md_content)
        print(f"Markdown file created: {output_file_path}")
    else:
        print(md_content)
    
    return md_content

def main():
    if len(sys.argv) < 2:
        print("Usage: python trello_parser.py <trello_export.json> [output.md]")
        print("Example: python trello_parser.py board_export.json project_tracker.md")
        sys.exit(1)
    
    json_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    try:
        parse_trello_export(json_file, output_file)
    except FileNotFoundError:
        print(f"Error: File {json_file} not found")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON in {json_file}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()