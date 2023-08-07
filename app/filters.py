import logging


class EndpointLoggingFilter(logging.Filter):
    """
    Filter out endpoints from access log
    """

    def filter(self, record: logging.LogRecord) -> bool:
        msg = record.getMessage()
        ignore_endpoints = ["/-/health", "/-/metrics"]
        for endpoint in ignore_endpoints:
            if endpoint in msg:
                return False
        return True
