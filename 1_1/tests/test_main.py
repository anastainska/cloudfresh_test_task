import unittest
from main import app


class BasicTests(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_index(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Let's eat!", response.data)

    def test_cafe(self):
        response = self.app.get('/cafe/McDonald\'s')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"This is McDonald's", response.data)


if __name__ == "__main__":
    unittest.main()
