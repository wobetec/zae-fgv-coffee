from abc import ABC, abstractmethod


class Report:
    def __init__(self):
        self.date = None
        self.sections = []

    def set_date(self, date):
        self.date = date

    def add_section(self, title, content):
        self.sections.append({"title": title, "content": content})

    def get_content(self):
        # Combine sections into a structured format
        report_content = f"Report Date: {self.date}\n\n"
        for section in self.sections:
            report_content += f"{section['title']}\n"
            report_content += "-" * len(section['title']) + "\n"
            report_content += section['content'] + "\n\n"
        return report_content
    
    def as_html(self):
        html_content = f"""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Daily Report for {self.date}</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    line-height: 1.6;
                    margin: 20px;
                    padding: 20px;
                    background-color: #f9f9f9;
                    color: #333;
                }}
                h1 {{
                    color: #2c3e50;
                }}
                .report {{
                    border: 1px solid #ddd;
                    padding: 15px;
                    background: #fff;
                    border-radius: 5px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }}
                .report h2 {{
                    margin-top: 0;
                }}
                .highlight {{
                    color: #e74c3c;
                    font-weight: bold;
                }}
            </style>
        </head>
        <body>
            <div class="report">
                <h1>Daily Report for {self.date}</h1>
                <hr> \n\n
        """
        for section in self.sections:
            html_content += f"""
                <h2>{section['title']}</h2>
                <p>{section['content'].replace('\n', '<br>')}</p> \n\n
            """
        html_content += """
            </div>
        </body>
        </html> \n\n
        """
        return html_content

class ReportBuilder(ABC):
    def __init__(self):
        self.report = Report()

    def set_date(self, date):
        self.report.set_date(date)

    @abstractmethod
    def build_basic_report(self, vending_machines, total_orders, total_sales, total_items):
        pass

    def get_report(self):
        return self.report

class DetailedReportBuilder(ReportBuilder):
    def __init__(self):
        super().__init__()

    def build_basic_report(self, vending_machines, total_orders, total_sales, total_items):
        content = (
            f"Number of vending machines: {len(vending_machines)}\n"
            f"Total orders placed: {total_orders}\n"
            f"Total sales amount: ${total_sales:.2f}\n"
            f"Total items sold: {total_items}\n"
        )
        self.report.add_section("Basic Report", content)

class ReportDirector:
    def __init__(self, builder):
        self.builder = builder

    def construct_report(self, date, vending_machines, total_orders, total_sales, total_items):
        self.builder.set_date(date)
        self.builder.build_basic_report(vending_machines, total_orders, total_sales, total_items)
        return self.builder.get_report()

