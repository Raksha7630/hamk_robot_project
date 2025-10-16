"""
Helper library for creating Chrome options with proper configuration.
"""
from selenium.webdriver import ChromeOptions
from selenium.webdriver.chrome.service import Service


def get_headless_chrome_options():
    """
    Returns a ChromeOptions object configured for headless execution.
    
    Returns:
        ChromeOptions: Configured Chrome options
    """
    options = ChromeOptions()
    options.add_argument('--headless=new')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1920,1080')
    return options


def get_chrome_options():
    """
    Returns a ChromeOptions object with basic stable configuration.
    
    Returns:
        ChromeOptions: Configured Chrome options
    """
    options = ChromeOptions()
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    return options


def get_chrome_service():
    """
    Returns a Service object for Chrome using system chromedriver.
    
    Returns:
        Service: Chrome service object
    """
    return Service('/usr/bin/chromedriver')
